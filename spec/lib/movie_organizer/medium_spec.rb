# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
module MovieOrganizer
  RSpec.describe Medium, type: :lib do
    include_context 'media_shared'

    context '::media_file?' do
      Dir[file_fixture_path.join('bad.*')].each do |vid|
        it "returns false for #{vid}" do
          expect(Medium.media_file?(vid)).to eq(false)
        end
      end

      Dir[file_fixture_path.join('good.*')].each do |vid|
        it "returns true for #{vid}" do
          expect(Medium.media_file?(vid)).to eq(true)
        end
      end
    end

    context '::build_instance', vcr: true do
      Dir[file_fixture_path.join('movies', '*')].each do |vid|
        it "returns a Movie instance type for #{vid}" do
          expect(Medium).to receive(:media_file?).and_return(true)
          instance = Medium.build_instance(vid)
          expect(instance).to be_a(Movie)
        end
      end

      Dir[file_fixture_path.join('tv_shows', '*')].each do |vid|
        it "returns a TvShow instance type for #{vid}" do
          expect(Medium).to receive(:media_file?).and_return(true)
          instance = Medium.build_instance(vid)
          expect(instance).to be_a(TvShow)
        end
      end
    end

    # context '.subtype' do
    #   tv_shows = {
    #     'SnnEnn' => 'The.Walking.Dead.S04E08.HDTV.x264-2HD',
    #     'nxn'    => 'The.Walking.Dead.4x0.HDTV.x264-2HD',
    #     'nnxn'   => 'The.Walking.Dead.12x8.HDTV.x264-2HD',
    #     'nnxnn'  => 'The.Walking.Dead.12x08.HDTV.x264-2HD',
    #     'nxnn'   => 'The.Walking.Dead.2x18.HDTV.x264-2HD'
    #   }
    #
    #   tv_shows.each_pair do |syntax, filename|
    #     it "returns a TvShow with season and episode syntax: #{syntax}" do
    #       filename = create_test_file(
    #         filename: filename,
    #         extension: 'mp4'
    #       ).first
    #       expect(Media.subtype(filename, default_options)).to be_a(TvShow)
    #     end
    #   end
    #
    #   movies = [
    #     'Coco.2017.1080p.BluRay.x264-[BOGUS.IT]',
    #     'Beetlejuice',
    #     'Justice.League.2017.1080p.BluRay.x264-[YTS.AM]',
    #     'Jumanji.Welcome.To.The.Jungle.2017.1080p.WEBRip.x264-[YTS.AM].mp4'
    #   ]
    #
    #   movies.each do |filename|
    #     it "returns a Movie for '#{filename}'" do
    #       expect(Tmdb::Movie).to receive(:find).at_least(1).times.and_return([1])
    #       filename = create_test_file(
    #         filename: filename
    #       ).first
    #       expect(Media.subtype(filename, default_options)).to be_a(Movie)
    #     end
    #   end
    #
    #   videos = [
    #     'IMG_2052',
    #     'IMG_3322',
    #     'VID_3322',
    #     'VIDEO_3322',
    #     'Our Summer Vacation',
    #     'Tom and Jerry on the Beach'
    #   ]
    #
    #   videos.each do |filename|
    #     it "returns a Video for '#{filename}'" do
    #       expect(Tmdb::Movie).to receive(:find).at_least(1).times.and_return([])
    #       filename = create_test_file(
    #         filename: filename
    #       ).first
    #       expect(Medium.subtype(filename, default_options)).to be_a(Video)
    #     end
    #   end
    # end
  end
end
# rubocop:enable Metrics/BlockLength
