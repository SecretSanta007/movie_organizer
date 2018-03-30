# frozen_string_literal: true

module MovieOrganizer
  class TvShow < Medium
    attr_reader :tvdb_instance, :preserve_episode_name

    S_E_EXPRESSIONS = [
      /(s(\d+)e(\d+))/i,
      /((\d+)x(\d+))/i
    ].freeze

    class << self
      def match?(filepath)
        index = nil
        clean_title = nil
        base = basename(filepath)
        sanitized = sanitize(base)
        S_E_EXPRESSIONS.each do |regex|
          next unless (md = sanitized.match(regex))
          index = sanitized.index(md[1], 0)
          clean_title = sanitized[0..index - 1].strip
          break
        end
        return false unless clean_title
        tvdb_instance = TvdbInstance.new(clean_title)
        return tvdb_instance if tvdb_instance.tv_show?
        false
      end
    end

    def initialize(filename, tvdb_instance)
      super(filename)
      @tvdb_instance         = tvdb_instance
      @season                = nil
      @episode               = nil
      @episode_title         = nil
      @season_and_episode    = nil
      @preserve_episode_name = false
    end

    # Set the target filename
    #
    def process!
      return nil if should_skip?

      @target = File.join(target_dir, processed_filename)
      Logger.instance.info("    target file: [#{@target.green.bold}]")
    end

    # Standardize the filename
    # @return [String] cleaned filename
    def processed_filename
      return nil if should_skip?
      if @preserve_episode_name && episode_title
        "#{title} - #{season_and_episode} - #{episode_title}#{extname}"
      else
        "#{title} - #{season_and_episode}#{extname}"
      end
    end

    def title
      tvdb_instance.match.title
    end

    def season
      return @season unless @season.nil?
      season_and_episode
      @season
    end

    private

    def should_skip?
      filename.match(/[\.\s-]?sample[\.\s-]?/)
    end

    def target_dir
      @target_dir ||= File.join(
        MovieOrganizer.tv_shows_directory,
        title,
        "Season #{season.sub(/^0+/, '')}"
      )
    end

    def episode_title
      return @episode_title unless @episode_title.nil?
      md = basename.match(/([^-]+)-([^-]+)-([^-]+)/)
      @episode_title = md[3].sub(/#{ext}$/, '').strip if md
      @episode_title
    end

    def season_and_episode
      return @season_and_episode unless @season_and_episode.nil?
      base = basename.gsub(/#{title}[\.\s]*/i, '')
      s_and_e_info = sanitize(base)
      S_E_EXPRESSIONS.each do |regex|
        md = s_and_e_info.match(regex)
        next unless md
        @season = md[2].rjust(2, '0')
        @episode = md[3].rjust(2, '0')
        @season_and_episode = "S#{@season}E#{@episode}"
        return @season_and_episode
      end
      @season_and_episode
    end
  end
end
