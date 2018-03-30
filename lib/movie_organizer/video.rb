# frozen_string_literal: true

require_relative 'string'

module MovieOrganizer
  class Video < Medium
    attr_reader :settings

    def initialize(filename, options)
      @settings = Settings.new
      super
    end

    def process!(file_copier = nil)
      target_file = File.join(target_dir, processed_filename)
      logger.info("    target dir: [#{target_dir}]")
      logger.info("    target file: [#{target_file.green.bold}]")
      fc = file_copier || FileCopier.new(filename, target_file, options)
      fc.copy
    end

    def processed_filename
      "#{title} (#{year})#{ext}"
    end

    def title
      @title ||= begin
        prompt = <<-STRING.here_with_pipe(' ')
          |Enter a friendly title for this video: [#{basename}]
          |or hit enter to keep the current title
        STRING
        new_title = MovieOrganizer.prompt_for(prompt, '')
        return File.basename(filename, ext) if new_title.nil? || new_title.empty?
        new_title
      end
    end

    def date_time
      filestat = File.stat(filename)
      filestat.birthtime.strftime('%Y-%m-%d @ %l:%M %p')
    end

    # private

    def target_dir
      File.join(MovieOrganizer.video_directory, "#{title} (#{date_time})")
    end
  end
end
