module MovieOrganizer
  class Movie < Media
    def initialize(filename, options)
      super
    end

    def process!
      settings = Settings.new
      target_dir = File.join(
        settings[:movies][:directory],
        "#{title} (#{year})"
      )
      FileUtils.mkdir_p(target_dir, noop: dry_run?)
      target_file = File.join(
        target_dir,
        processed_filename
      )
      logger.info("    target dir: [#{target_dir}]")
      logger.info("    target file: [#{target_file.green.bold}]")
      FileUtils.move(
        filename,
        target_file,
        force: true, noop: dry_run?
      )
    end

    def processed_filename
      "#{title} (#{year})#{ext}"
    end

    def title
      ext_regex = Regexp.new(ext.sub(/\./, '\\.'))
      newbase = sanitize(
        basename.sub(/#{ext_regex}$/, '').sub(/\(?#{year}\)?/, '')
      )
      @title ||= "#{newbase}"
    end
  end
end
