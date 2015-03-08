module MovieOrganizer
  class Organizer
    attr_accessor :logger

    # Make a singleton but allow the class to be instantiated for easier testing
    def self.instance
      @instance || new
    end

    def initialize
      @logger = Logger.instance
    end

    def start
      logger.info('Starting...')
    end
  end
end
