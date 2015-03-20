module MovieOrganizer
  class TvShow < Media
    S_E_EXPRESSIONS = [
      /(s(\d+)e(\d+))/i,
      /((\d+)x(\d+))/i,
      /[\.\s]((\d)(\d+))[\.\s]/i
    ]

    def initialize(filename, options)
      super
      @season = nil
      @episode = nil
      @episode_title = nil
    end

    def process!
      return nil if should_skip?
      # rename the file
      fail "Show not configured #{basename}" if title.nil?
      target_dir = File.join(
        settings[:tv_shows][:directory],
        title,
        "Season #{season.sub(/^0+/, '')}"
      )
      FileUtils.mkdir_p(target_dir, noop: dry_run?)
      target_file = File.join(target_dir, processed_filename)
      logger.info("    target dir: [#{target_dir}]")
      logger.info("    target file: [#{target_file}]")
      FileUtils.move(
        filename,
        target_file,
        force: true, noop: dry_run?
      )
    rescue ArgumentError => err
      raise err unless err.message.match(/^same file:/)
    end

    # Standardize the filename
    # @return [String] cleaned filename
    def processed_filename
      return nil if should_skip?
      if episode_title
        "#{title} - #{season_and_episode} - #{episode_title}#{ext}"
      else
        "#{title} - #{season_and_episode}#{ext}"
      end
    end

    def title
      return @title unless @title.nil?
      settings[:tv_shows][:my_shows].each do |show|
        md = sanitize(basename).match(Regexp.new(show, Regexp::IGNORECASE))
        if md
          @title = md[0].titleize
          break
        end
      end
      @title
    end

    def season
      return @season unless @season.nil?
      season_and_episode
      @season
    end

    private

    def should_skip?
      filename.match(/[\.\s]sample[\.\s]/)
    end

    def episode_title
      return @episode_title unless @episode_title.nil?
      if basename =~ /([^-]+)-([^-]+)-([^-]+)/
        @episode_title = $3.sub(/#{ext}$/, '').strip
      end
      @episode_title
    end

    def season_and_episode
      return @season_and_episode unless @season_and_episode.nil?
      S_E_EXPRESSIONS.each do |regex|
        clean_basename = sanitize(basename)
        s_and_e_info = clean_basename.sub(Regexp.new(title, Regexp::IGNORECASE), '')
        md = s_and_e_info.match(regex)
        if md
          @season = md[2].rjust(2, '0')
          @episode = md[3].rjust(2, '0')
          @season_and_episode = "S#{@season}E#{@episode}"
          return @season_and_episode
        end
      end
      @season_and_episode
    end

    def sanitize(str)
      cleanstr = str.gsub(/-\s*-/, '')
      cleanstr = cleanstr.gsub(/\[?1080p\]?/, '').strip
      cleanstr = cleanstr.gsub(/\[?720p\]?/, '').strip
      cleanstr = cleanstr.gsub(/BluRay/i, '').strip
      cleanstr = cleanstr.gsub(/HDTV/i, '').strip
      cleanstr = cleanstr.gsub(/-lol/i, '').strip
      cleanstr = cleanstr.gsub(/x264/, '').strip
      cleanstr = cleanstr.gsub(/[\.\s]us[\.\s]/i, '').strip
      cleanstr = cleanstr.gsub(/-\s*/, '').strip
      cleanstr.gsub(/[\.\+]/, ' ').strip
    end
  end
end
