require 'tinder'
require 'yajl'
require 'yajl/http_stream'

module Marvin
  class Bot

    def initialize
      @campfire = Tinder::Campfire.new( Marvin.subdomain, :token => Marvin.token )
      join_room!
    end

    def room_uri
      @room_uri ||= URI.parse(
        "http://#{Marvin.token}:x@streaming.campfirenow.com//room/#{@room.id}/live.json"
      )
    end

    def run
      Yajl::HttpStream.get(room_uri, :symbolize_keys => true) do |message|
        unless message[:user_id] == user_id
          @start_time = Time.now
          case message[:type]
          when 'TextMessage'
            handle_message(message)
          else
            Marvin.logger.debug "not processing #{message[:type]}"
          end
          Marvin.logger.debug "- #{(1000 * (Time.now - @start_time)).to_i}s"
        end
      end
    ensure
      leave_room!
    end

    def join_room!
      @room = @campfire.rooms.first
      @room.join
      say "Mornin!"
      Marvin.logger.info "Marvin joined #{@room.name}" 
    end

    def leave_room! 
      say "Goodbye forever"
      @room.leave
      Marvin.logger.info "Marvin left #{@room.name}" 
    end

    def say(text)
      @room.speak(text)
    end

    def user_id
      @user_id ||= @campfire.me[:id]
    end

    def memory
      @memory ||= Marvin::Memory.new
    end

    private

    def handle_message(message)
      if /^marvin(,\ ?|\ )(?<command>.*)/i =~ message[:body]
        case command
        when /who am i\??/i
          say "You're #{@room.user(message[:user_id])[:name]}"
        when /remember (.*) is (.*)/
          memory.remember $1, $2
          say "Okay, I've got it" 
        when /remember (.*)/
          if result = memory.remember($1)
            say result
          else
            say "Nope, I don't remember that."
          end
        when /crash!?/
          if message[:user_id] == "662661"
            raise "Creator Forced Crash"
          else
            say "Going down in 3.."
            sleep 1
            say "2.."
            sleep 1
            say "1.."
            sleep 1
            say "Hah! I can only be crashed by my creator!"
          end
        else
          say "Are you talking to me?"
        end
      else
        case message[:body]
        when /\ marvin\ /i
          say "Are you talking about me?"
        when /^night?time!?/i
          say "Daytime!"
        when /^daytime!?/i
          say "Nighttime!"
        when /shut\ ?up marvin!?/i
          say "You shut up!"
        when /^y/i
          say "Fantastic!"
        when /^n/i
          say "Well why not?"
        end
      end
    end

  end
end
