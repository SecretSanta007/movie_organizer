# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
module MovieOrganizer
  RSpec.describe Media, type: :lib do
    include_context 'media_shared'

    context '.subtype' do
      tv_shows = {
        'SnnEnn' => 'The.Walking.Dead.S04E08.HDTV.x264-2HD',
        'nxn'    => 'The.Walking.Dead.4x0.HDTV.x264-2HD',
        'nnxn'   => 'The.Walking.Dead.12x8.HDTV.x264-2HD',
        'nnxnn'  => 'The.Walking.Dead.12x08.HDTV.x264-2HD',
        'nxnn'   => 'The.Walking.Dead.2x18.HDTV.x264-2HD'
      }

      tv_shows.each_pair do |syntax, filename|
        it "returns a TvShow with season and episode syntax: #{syntax}" do
          filename = create_test_file(
            filename: filename,
            extension: 'mp4'
          ).first
          expect(Media.subtype(filename, default_options)).to be_a(TvShow)
        end
      end

      movies = [
        'Coco.2017.1080p.BluRay.x264-[BOGUS.IT]',
        'Beetlejuice',
        'Justice.League.2017.1080p.BluRay.x264-[YTS.AM]'
      ]

      movies.each do |filename|
        it "returns a Movie for '#{filename}'" do
          filename = create_test_file(
            filename: filename
          ).first
          expect(Media.subtype(filename, default_options)).to be_a(Movie)
        end
      end

      videos = [
        'IMG_2052',
        'IMG_3322',
        'VID_3322',
        'VIDEO_3322',
        'Our Summer Vacation',
        'Tom and Jerry on the Beach'
      ]

      videos.each do |filename|
        it "returns a Video for '#{filename}'" do
          filename = create_test_file(
            filename: filename
          ).first
          expect(Media.subtype(filename, default_options)).to be_a(Video)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
