require 'titleize'

module MovieOrganizer
  class Movie < Media
    def initialize(filename)
      super
    end

    def process!
      settings = Settings.new
      target_dir = File.join(settings[:movies][:directory], title)
      FileUtils.mkdir_p(target_dir)
      target_file = File.join(target_dir, processed_filename)
      FileUtils.move(filename, target_file)
    end

    def processed_filename
      "#{title}#{ext}"
    end

    def title
      ext_regex = Regexp.new(ext.sub(/\./, '\\.'))
      newbase = sanitize(basename.sub(/#{ext_regex}$/, ''))
      @title ||= "#{newbase}"
    end

    private

    def basename
      File.basename(filename)
    end

    def ext
      File.extname(filename)
    end

    def sanitize(str)
      newstr = str.gsub(/1080p/, '').strip
      newstr = newstr.gsub(/720p/, '').strip
      newstr = newstr.gsub(/EXTENDED/, '').strip
      newstr = newstr.gsub(/\s\s+/, ' ').strip
      newstr.gsub(/[\.\+]/, ' ').strip
    end
  end
end
