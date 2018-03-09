# frozen_string_literal: true

require 'net/scp'
require 'net/ssh'

module MovieOrganizer
  class Movie < Media
    def initialize(filename, options)
      super
    end

    def process!
      target_dir = File.join(MovieOrganizer.movie_directory, "#{title} (#{year})")
      target_file = File.join(target_dir, processed_filename)
      # logger.info("    target dir: [#{target_dir}]")
      logger.info("    target file: [#{target_file.green.bold}]")
      fc = FileCopier.new(filename, target_file, options)
      fc.copy
    end

    def processed_filename
      "#{title} (#{year})#{ext}"
    end

    def title
      ext_regex = Regexp.new(ext.sub(/\./, '\\.'))
      newbase = sanitize(
        basename.sub(/#{ext_regex}$/, '').sub(/\(?#{year}\)?/, '')
      )
      @title ||= newbase
    end
  end
end
