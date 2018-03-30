# frozen_string_literal: true

# A cached movie lookup instance
module MovieOrganizer
  class TmdbInstance
    attr_reader :title, :year, :matches

    def initialize(title, year = nil)
      Tmdb::Api.key(ENV.fetch('TMDB_KEY')) # configure TMDB API key
      @title = title
      @year  = year
    end

    def movie?
      @matches = Tmdb::Movie.find(title)
      sleep(0.25)
      return self if matches.any?
      false
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Style/RescueModifier
    def likely_match
      @likely_match ||= begin
        if year.nil?
          lm = matches.first
          release_date = Date.parse(lm.release_date) rescue nil
          @title = lm.title
          @year = release_date&.year
        else
          lm = nil
          matches.each do |m|
            release_date = Date.parse(m.release_date) rescue nil
            next unless release_date&.year.to_i == year.to_i
            lm = m
            @title = lm.title
            @year = release_date&.year
            break
          end
          lm ||= matches.first
        end
        lm
      end
    end
    # rubocop:enable Style/RescueModifier
    # rubocop:enable Metrics/AbcSize
  end
end
