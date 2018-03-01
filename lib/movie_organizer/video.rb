# frozen_string_literal: true

module MovieOrganizer
  class Video < Media
    attr_reader :settings

    def initialize(filename, options)
      @settings = Settings.new
      super
    end

    def process!
      binding.pry
      FileUtils.mkdir_p(target_dir, noop: dry_run?)
      logger.info("    target dir: [#{target_dir}]")
      logger.info("    target file: [#{target_file.green.bold}]")
      FileUtils.move(filename, target_file, force: true, noop: dry_run?)
    end

    def processed_filename
      "#{title} (#{year})#{ext}"
    end

    def title
      @title ||= begin
        temp = MovieOrganizer.prompt_for(
          <<-STRING.here_with_pipe(' ')
            |Please enter a friendly title for this video: [#{filename}]
            |or just hit enter to keep the current title
          STRING
        )
        binding.pry
      end
    end

    def date_time
      filestat = File.stat(filename)
      filestat.birthtime.strftime('%Y-%m-%d @ %l:%M %p')
    end

    # private

    def target_dir
      File.join(settings[:videos][:directory], "#{title} (#{date_time})")
    end
  end
end
