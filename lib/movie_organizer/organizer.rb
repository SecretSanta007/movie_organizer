# frozen_string_literal: true

require 'trollop'
require 'colored'

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
      start_time = Time.now
      @options = collect_args
      logger.info('Starting MovieOrganizer...'.green)
      count = 0

      # Enumerate all of the new source media
      @media_list = MediaList.new(MovieOrganizer.source_directories)

      # Process each source file
      @media_list.file_collection.each do |file|
        # Get movie or TV show information so we can rename the file if necessary
        media = Media.subtype(file, options)
        # Move and/or rename the file
        logger.info("Processing [#{file}] - #{media.class.to_s.yellow}")
        media.process!
        count += 1
      end
      elapsed = Time.now - start_time
      logger.info("Processed #{count} vidoes in [#{elapsed}] seconds.".yellow)
    end

    private

    def collect_args
      Trollop.options do
        opt(
          :source_dir,
          'Source directories containing media files. Colon (:) separated.',
          type: :string, required: false, short: '-s')
        opt(
          :dry_run,
          'Do not actually move or copy files',
          type: :boolean, required: false, short: '-d',
          default: false)
        opt(
          :preserve_episode_name,
          'Preserve episode names if they exist (experimental)',
          type: :boolean, required: false, short: '-p',
          default: false)
        opt(
          :verbose,
          'Be verbose with output',
          type: :boolean, required: false, short: '-v',
          default: false)
      end
    end
  end
end
