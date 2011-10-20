module Marvin
  class Mouth < Attachment

    attach do

    end

    detach do

    end

    def say(message)
      @room.speak
    end

  end
end
