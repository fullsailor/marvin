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

    private

    def handle_message(message)
      case message[:body]
      when /^marvin,? who am i\??/i
        say "You're #{@room.user(message[:user_id])[:name]}"
      when /^marvin,?\ /i
        say "Are you talking to me?"
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
