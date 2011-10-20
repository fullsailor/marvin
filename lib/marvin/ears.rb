module Marvin
  class Ears

    attach do
      join_room!
    end

    detach do
      leave_room!
    end

    def listen
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
    end

    private

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

  end
end
