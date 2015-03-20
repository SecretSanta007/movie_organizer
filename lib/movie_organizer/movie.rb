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
      logger.info("    target file: [#{target_file}]")
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

    def year
      md = basename.match(/\((\d\d\d\d)\)|(19\d\d)|(20\d\d)/)
      md ? md.captures.compact.first : nil
    end

    private

    def basename
      File.basename(filename)
    end

    def ext
      File.extname(filename)
    end

    def sanitize(str)
      newstr = str.gsub(/\[?1080p\]?/, '').strip
      newstr = newstr.gsub(/\[?720p\]?/, '').strip
      newstr = newstr.gsub(/EXTENDED/, '').strip
      newstr = newstr.gsub(/YIFY/, '').strip
      newstr = newstr.gsub(/BluRay/, '').strip
      newstr = newstr.gsub(/x264/, '').strip
      newstr = newstr.gsub(/\s\s+/, ' ').strip
      newstr.gsub(/[\.\+]/, ' ').strip
    end
  end
end
