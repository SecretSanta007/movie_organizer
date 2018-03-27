# frozen_string_literal: true

require 'titleize'
require 'themoviedb'

module MovieOrganizer
  # This meta-class factory accepts the media filename, and from that
  # determines if it is likely to be:
  #
  # 1. a TV show
  # 2. a Movie
  # 3. a home video or other type
  class Media
    attr_accessor :filename, :options, :logger, :settings

    def self.subtype(filename, options)
      instance = new(filename, options)
      return TvShow.new(filename, options) if instance.tv_show?
      return Movie.new(filename, options) if instance.movie?
      Video.new(filename, options)
    end

    def initialize(filename, options)
      @filename = filename
      @options = options
      @tv_show = nil
      @logger = Logger.instance
      @settings = Settings.new
    end

    def tv_show?
      return @tv_show unless @tv_show.nil?
      @tv_show = false
      @tv_show = true unless filename.match(/S\d+E\d+/i).nil?
      @tv_show = true unless filename.match(/\d+x\d+/i).nil?
      @tv_show
    end

    def movie?
      return @movie unless @movie.nil?
      @movie = false
      Tmdb::Api.key(MovieOrganizer.tmdb_key)
      # Remove the year and sanitize
      title = sanitize(File.basename(filename, ext)).gsub(/[\s\.\-\_]\(?\d\d\d\d\)?/, '').strip
      matches = Tmdb::Movie.find(title)
      @movie = matches.any?
      @movie
    end

    def year
      md = basename.match(/\((\d\d\d\d)\)|(19\d\d)|(20\d\d)/)
      # try dirname if filename has no year
      md = dirname.match(/\((\d\d\d\d)\)|(19\d\d)|(20\d\d)/) if md.nil?
      md ? md.captures.compact.first : nil
    end

    protected

    def basename
      File.basename(filename)
    end

    def ext
      File.extname(filename)
    end

    def dirname
      File.dirname(filename)
    end

    def verbose?
      options[:verbose]
    end

    def dry_run?
      options[:dry_run]
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def sanitize(str)
      cleanstr = str.gsub(/-\s*-/, '')
      cleanstr = cleanstr.gsub(/\[?1080p\]?/, '').strip
      cleanstr = cleanstr.gsub(/m?\[?720p\]?/, '').strip
      cleanstr = cleanstr.gsub(/\[[^\]]+\]/, '').strip
      cleanstr = cleanstr.gsub(/EXTENDED/, '').strip
      cleanstr = cleanstr.gsub(/YIFY/, '').strip
      cleanstr = cleanstr.gsub(/VPPV/, '').strip
      cleanstr = cleanstr.gsub(/BluRay/i, '').strip
      cleanstr = cleanstr.gsub(/BrRip/i, '').strip
      cleanstr = cleanstr.gsub(/[\s\.]Br[\s\.]?/i, '').strip
      cleanstr = cleanstr.gsub(/BdRip/i, '').strip
      cleanstr = cleanstr.gsub(/ECI/i, '').strip
      cleanstr = cleanstr.gsub(/HDTV/i, '').strip
      cleanstr = cleanstr.gsub(/WEBRip/i, '').strip
      cleanstr = cleanstr.gsub(/x264/, '').strip
      cleanstr = cleanstr.gsub(/AAC/, '').strip
      cleanstr = cleanstr.gsub(/-lol/i, '').strip
      cleanstr = cleanstr.gsub(/\+HI/i, '').strip
      cleanstr = cleanstr.gsub(/muxed/i, '').strip
      cleanstr = cleanstr.gsub(/\d\d\d+mb/i, '').strip
      # cleanstr = cleanstr.gsub(/[\.\s-]us[\.\s-]/i, ' ').strip
      cleanstr = cleanstr.gsub(/-\s*/, '').strip
      cleanstr = cleanstr.gsub(/\s\s+/, ' ').strip
      cleanstr.gsub(/[\.\+]/, ' ').strip
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
