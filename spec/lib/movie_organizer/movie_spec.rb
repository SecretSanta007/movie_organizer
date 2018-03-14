# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
module MovieOrganizer
  RSpec.describe Movie, type: :lib do
    include_context 'media_shared'

    movies = {
      'Coco.2017.1080p.BluRay.x264-[BOGUS.IT]' => {
        year: '2017',
        name: 'Coco (2017).mp4'
      },
      'Beetlejuice' => {
        year: nil,
        name: 'Beetlejuice ().mp4'
      },
      'Justice.League.2017.1080p.BluRay.x264-[YTS.AM]' => {
        year: '2017',
        name: 'Justice League (2017).mp4'
      },
      'Jumanji.Welcome.To.The.Jungle.2017.1080p.WEBRip.x264-[YTS.AM]' => {
        year: '2017',
        name: 'Jumanji Welcome To The Jungle (2017).mp4'
      }
    }

    movies.each_pair do |filename, data|
      context filename do
        before(:each) do
          @filepath = create_test_file(filename: filename, extension: 'mp4').first
          @expected_filename = data[:name]
          @expected_year = data[:year]
          @movie = Movie.new(@filepath, default_options)
        end

        context '.processed_filename' do
          it "correctly processes the filename: [#{filename}]" do
            expect(
              @movie.processed_filename
            ).to eq(@expected_filename)
          end
        end

        context '.year' do
          it 'returns the correct year' do
            expect(@movie.year).to eq(@expected_year)
          end
        end
      end
    end

    context 'single movie' do
      let(:filename) do
        create_test_file(
          filename: 'Foreign+Correspondent+(1940)+1080p', extension: 'mp4'
        ).first
      end
      let(:movie) { Movie.new(filename, default_options) }

      context '#new' do
        it 'is a Movie' do
          expect(movie).to be_a(Movie)
        end

        it 'sets filename accessor' do
          expect(movie.filename).to eq(filename)
        end
      end

      context '.process!' do
        it 'moves the file to the configured location' do
          settings = Settings.new
          settings[:movies][:directory] = MovieOrganizer.root.join('tmp', 'files', 'movies').to_s
          settings.save
          movie.process!
          expect(File.exist?(filename)).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
