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
        case message[:type]
        when 'TextMessage'
          handle_message(message)
        else
          puts "not processing #{message[:type]}"
        end
      end
    ensure
      leave_room!
    end

    def join_room!
      @room = @campfire.rooms.first
      @room.join
      say "Mornin!"
      self
    end

    def leave_room! 
      say "Goodbye forever"
      @room.leave
      self
    end

    def say(text)
      @room.speak(text)
      self
    end


    private

    def handle_message(message)
      case message[:body]
      when /^marvin\ /i
        say "Are you talking to me?"
      when /marvin/i
        say "Are you talking about me?"
      when /^y/i
        say "Fantastic!"
      when /^n/i
        say "Well why not?"
      end
    end

  end
end
