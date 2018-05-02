# frozen_string_literal: true

module MovieOrganizer
  class Movie < Medium
    attr_reader :tmdb_instance

    class << self
      # Determine if the passed file is most likely a Movie.
      # If it is, that usually means the file was named with movie title and year somwehere in
      # the filename
      #
      # @return [Boolean] TmdbInstance if likely a Movie, false if not
      def match?(filepath)
        base          = basename(filepath)
        possible_year = possible_year_in_title(base)
        clean_title   = sanitize(base).gsub(/[\s\.\-\_]\(?\d+\s*\)?$/, '')
        tmdb_instance = TmdbInstance.new(clean_title, possible_year)
        return tmdb_instance if tmdb_instance.movie?
        false
      end

      private

      def possible_year_in_title(title)
        title_with_year = sanitize(title)
        md = title_with_year.match(/(\d{4}+)/)
        md ? md[1] : nil
      end
    end

    def initialize(filename, tmdb_instance)
      super(filename)
      @tmdb_instance = tmdb_instance
    end

    # Set the target filename
    #
    def process!
      return nil unless tmdb_instance
      tmdb_instance.likely_match
      @target = File.join(target_dir, processed_filename)
      Logger.instance.info("    target file: [#{@target.green.bold}]")
    end

    def processed_filename
      "#{title} (#{year})#{extname}"
    end

    def title
      return sanitize(basename).gsub(/[\s\.\-\_]\(?\s*\d+\s*\)?/, '') unless tmdb_instance
      tmdb_instance.title
    end

    def year
      return nil unless tmdb_instance
      tmdb_instance.year
    end

    private

    def target_dir
      @target_dir ||= File.join(MovieOrganizer.movie_directory, "#{title} (#{year})")
    end
  end
end
