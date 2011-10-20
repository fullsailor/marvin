module Marvin
  class Attachment

    def self.attach(&block)
      @@attach_list ||= []
      @@attach_list << block
    end

    def self.detach(&block)
      @@detach_list ||= []
      @@detach_list << block
    end

    def initialize
      @@attach_list.each(&:call) if @@attach_list
        
      
    end


    private

  end
end
