require 'streamio-ffmpeg'

module MovieOrganizer
  # This meta-class factory should accept the media filename, and from that
  # determine if it is likely to be:
  #
  # 1. a TV show
  # 2. a Movie
  # 3. a home video or other arbitrary video
  class Media
    attr_accessor :filename

    def self.subtype(filename)
      instance = new(filename)
      return TvShow.new(filename) if instance.tv_show?
    end

    def initialize(filename)
      @filename = filename
    end

    def tv_show?
      @tv_show ||= !filename.match(/S\d+E\d+/i).nil?
    end

    def resolution
      video = FFMPEG::Movie.new(filename)

      # first check the resolution field
      md = video.resolution.match(/^\d+x\d+$/)
      return md.string.split('x').last.to_i unless md.nil?

      # next check video stream
      md = video.video_stream.match(/\d\d\d+x\d\d\d+/)
      return md.string.split('x').last.to_i unless md.nil?

      fail "Cannot determine resolution\n#{video.inspect}"
    end
  end
end
