# frozen_string_literal: true

require 'filemagic'
require 'themoviedb'

module MovieOrganizer
  # Medium is a class factory for it's derived classes
  class Medium
    attr_reader :filename, :target

    MIME_TYPES = %w[
      video/mp4
      video/ogg
      video/webm
      video/mpeg
      video/quicktime
      video/x-matroska
      video/x-msvideo
    ].freeze
    OCTET_STREAM_EXTENSIONS = %w[.3gp .mp4].freeze

    class << self
      # Determine if a file is a processable media file
      #
      # @return [Boolean] true if file is processable, false if not
      def media_file?(filepath)
        return false if File.directory?(filepath)

        MovieOrganizer.verbose_puts("checking: #{filepath}")

        mime = mime_type(filepath)

        return true if
          mime == 'application/octet-stream' &&
          OCTET_STREAM_EXTENSIONS.include?(File.extname(filepath))

        MIME_TYPES.include?(mime)
      end

      # Build the proper instance of a child class. This method does not check if the file is
      # of the proper mime-type
      #
      # @param filepath [String] full path to the file
      # @return [Object] instance of the corresponding class type
      def build_instance(filepath)
        return nil unless media_file?(filepath)

        tvdb_instance = TvShow.match?(filepath)
        return TvShow.new(filepath, tvdb_instance) if tvdb_instance

        tmdb_instance = Movie.match?(filepath)
        return Movie.new(filepath, tmdb_instance) if tmdb_instance

        # return Video.new(filepath) if Video.match?(filepath)

        nil
      end

      private

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def sanitize(str)
        cleanstr = str.dup
        cleanstr.gsub!(/-\s*-/, '')
        cleanstr.gsub!(/\[?1080p\]?/, '')
        cleanstr.gsub!(/m?\[?720p\]?/, '')
        cleanstr.gsub!(/\[[^\]]+\]/, '')
        cleanstr.gsub!(/ECI/, '')
        cleanstr.gsub!(/EXTENDED/, '')
        cleanstr.gsub!(/UNRATED/, '')
        cleanstr.gsub!(/ETRG/, '')
        cleanstr.gsub!(/(Deceit)?\.?YIFY/, '')
        cleanstr.gsub!(/VPPV/, '')
        cleanstr.gsub!(/HQ/, '')
        cleanstr.gsub!(/x264/, '')
        cleanstr.gsub!(/AAC/, '')
        cleanstr.gsub!(/BrRip/, '')
        cleanstr.gsub!(/BdRip/, '')
        cleanstr.gsub!(/BluRay/i, '')
        cleanstr.gsub!(/HDTV/i, '')
        cleanstr.gsub!(/WEBRip/i, '')
        cleanstr.gsub!(/-?xvid-?/i, '')
        cleanstr.gsub!(/-?maxspeed/i, '')
        cleanstr.gsub!(/www\.torentz\.3xforum\.ro\.avi/i, '')
        cleanstr.gsub!(/-lol/i, '')
        cleanstr.gsub!(/\+HI/i, '')
        cleanstr.gsub!(/muxed/i, '')
        cleanstr.gsub!(/\(dvd\)/i, '')
        cleanstr.gsub!(/dvdscr/i, '')
        cleanstr.gsub!(/mkv/i, '')
        cleanstr.gsub!(/aqos/i, '')
        cleanstr.gsub!(/ac3/i, '')
        cleanstr.gsub!(/hive/i, '')
        cleanstr.gsub!(/-?cm8/i, '')
        cleanstr.gsub!(/[\d\.]+mb/i, '')
        cleanstr.gsub!(/[\d\.]+gb/i, '')
        cleanstr.gsub!(/\s\s+/, ' ')
        cleanstr.tr!('_', ' ') # underscores
        cleanstr.gsub!(/[\.\+]/, ' ')
        cleanstr.strip!
        cleanstr
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def basename(filepath)
        File.basename(filepath, extname(filepath))
      end

      def extname(filepath)
        File.extname(filepath)
      end

      def dirname(filepath)
        File.dirname(filepath)
      end

      def mime_type(filepath)
        file_magic ||= FileMagic.mime
        mime_str = file_magic.file(filepath.to_s)
        mime_str.split(/;/).first
      end
    end

    def initialize(filename)
      @filename = filename
    end

    def basename
      self.class.send(:basename, filename)
    end

    def extname
      self.class.send(:extname, filename)
    end

    def dirname
      self.class.send(:dirname, filename)
    end

    def sanitized_basename
      self.class.send(:sanitize, basename)
    end

    def sanitize(str)
      self.class.send(:sanitize, str)
    end

    # Determine the supposed year in the filename or directory to match against
    # the release date for a potential movie
    #
    # @return [String] Year derived from the filename or directory
    def derived_year
      @derived_year ||= begin
        md = basename.match(/\((\d\d\d\d)\)|(19\d\d)|(20\d\d)/)
        # try dirname if filename has no year
        md = dirname.match(/\((\d\d\d\d)\)|(19\d\d)|(20\d\d)/) if md.nil?
        md ? md.captures.compact.first : nil
      end
    end

    def year
      release_date&.year
    end

    # Groom the filename to reflect a proper naming scheme.
    # Copy file to the configured destination.
    #
    def groom
      process!
      fc = FileCopier.new(filename, target)
      fc.copy!
    end
  end
end
