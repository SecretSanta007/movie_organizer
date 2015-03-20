require 'mime/types'

module MovieOrganizer
  class MediaList
    attr_accessor :file_collection

    # Walk the directory trees of 'directories', finding all pertinent media
    # files
    def initialize(directories = MovieOrganizer.source_directories)
      @file_collection = []
      directories.each do |directory|
        Dir["#{directory}/**/*"].each do |entry|
          file_collection << entry if media?(entry)
        end
      end
    end

    def media?(filename)
      video?(filename) || subtitle?(filename)
    end

    def video?(filename)
      MIME::Types.of(filename).map(&:media_type).include?('video')
    end

    def subtitle?(filename)
      !MIME::Types.of(filename).map(&:content_type).grep(/(subtitle$|subrip$)/).empty?
    end
  end
end
