require 'pry'
require 'trollop'

module MovieOrganizer
  class Organizer
    attr_accessor :logger, :options

    # Make a singleton but allow the class to be instantiated for easier testing
    def self.instance
      @instance || new
    end

    def initialize
      @logger = Logger.instance
    end

    def start
      logger.info('Starting...')
      opts = collect_args

      # Enumerate all of the new source media
      @media_list = MediaList.new(opts[:source_dir].split(':'))

      # Process each source file
      @media_list.file_collection.each do |file|
        # Get movie or TV show information so we can rename the file if necessary
        media = Media.subtype(file)
        # Move and/or rename the file
        logger.info("Processing [#{file}]")
        media.process!
      end
    end

    private

    def collect_args
      Trollop.options do
        opt(
          :source_dir,
          'Source directories containing media files. Colon (:) separated.',
          type: :string, required: false, short: '-s',
          default: "#{MovieOrganizer.source_directories.join(' ')}")
      end
    end
  end
end

# Configure TV Shows
# The Walking Dead
# Spaces can be periods
# Configure Season and Episode naming
# Move TV Shows into their proper 'season' directory
