# frozen_string_literal: true

require_relative 'string'

module MovieOrganizer
  class Video < Medium
    attr_reader :settings

    VIDEO_EXTENSIONS = %w[
      .m4v .mp4 .ogg .webm .mpeg .mpg .mov .mkv .avi
    ].freeze

    class << self
      # This should be the last Media type to match on.
      # Pretty much if the .ext matches video file types then consider it a video.
      #
      # @return [Boolean] true if matches file extensions, false if not
      def match?(filepath)
        return true if VIDEO_EXTENSIONS.include?(extname(filepath))
        false
      end
    end

    def initialize(filename)
      @settings = Settings.instance
      super
    end

    def process!(file_copier = nil)
      target_file = File.join(target_dir, processed_filename)
      Logger.instance.info("    target file: [#{target_file.green.bold}]")
      fc = file_copier || FileCopier.new(filename, target_file, options)
      fc.copy!
    end

    def processed_filename
      "#{title} (#{year})#{extname}"
    end

    def title
      @title ||= begin
        prompt = <<-STRING.here_with_pipe(' ')
          |Enter a friendly title for this video: [#{basename}]
          |or hit enter to keep the current title
        STRING
        new_title = MovieOrganizer.prompt_for(prompt, '')
        return File.basename(filename, extname) if new_title.nil? || new_title.empty?
        new_title
      end
    end

    def date_time
      release_date&.strftime('%Y-%m-%d @ %l:%M %p')
    end

    # Return assumed year of video.
    # First try to get it from the filename itself
    # Next get it from the operating system's creation date of the file
    #
    # @return [Fixnum] Assumed year of the video file
    def year
      derived = derived_year
      return derived if derived
      release_date&.year
    end

    def target_dir
      File.join(MovieOrganizer.video_directory, "#{title} (#{date_time})")
    end

    def release_date
      st = File.stat(filename)
      return st.birthtime unless MovieOrganizer.os == :retarded
      st.ctime
    end
  end
end
