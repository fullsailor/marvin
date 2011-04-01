module Marvin
  # Basic short-term memory
  class Memory

    def initialize
      @memory = {}
    end

    def remember(key, val=nil)
      val ? store(key,val) : retrieve(key)
    end

    def store(key, val)
      @memory[key.to_s] = val
    end

    def retrieve(key)
      @memory[key.to_s]
    end

  end
end
