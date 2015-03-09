require 'titleize'

module MovieOrganizer
  class TvShow < Media
    attr_accessor :filename

    def initialize(filename)
      super
    end

    def process!
      settings = Settings.new
      # rename the file
      target_dir = File.join(
        settings[:tv_shows][:directory],
        title,
        "Season #{season}"
      )
      FileUtils.mkdir_p(target_dir)
      target_file = File.join(target_dir, processed_filename)
      FileUtils.move(filename, target_file)
    end

    # Standardize the filename
    # @return [String] cleaned filename
    def processed_filename
      "#{title} - #{season_and_episode}#{ext}"
    end

    private

    def season_and_episode
      @season_string ||= $1 if filename =~ /(s\d+e\d+)/i
    end

    def season
      season_str = season_and_episode.split('E').first
      season_str.sub(/^S0*/i, '')
    end

    def basename
      File.basename(filename)
    end

    # Typically everything that comes before the season and episode
    def title
      @title ||= sanitize($1) if basename =~ /^(.+)#{season_and_episode}/i
    end

    def ext
      File.extname(filename)
    end

    def sanitize(str)
      str.gsub(/[\.\+]/, ' ').strip
    end
  end
end
