# frozen_string_literal: true

module MovieOrganizer
  class MediaList
    attr_accessor :file_collection

    # Walk the source_directories finding all pertinent media files
    def initialize(directories = MovieOrganizer.source_directories)
      @file_collection = []
      directories.each do |directory|
        Dir["#{directory}/**/*"].each do |entry|
          file_collection << entry if Medium.media_file?(entry)
        end
      end
    end
  end
end
