# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/ModuleLength
module MovieOrganizer
  RSpec.describe Movie, type: :lib, vcr: true do
    include_context 'media_shared'

    movies = {
      'Coco.2017.1080p.BluRay.x264-[BOGUS.IT]' => {
        year: '2017',
        name: 'Coco (2017).mp4'
      },
      'Beetlejuice' => {
        directory: 'Beetlejuice (1988)',
        year: '1988',
        name: 'Beetlejuice (1988).mp4'
      },
      'Justice.League.2017.1080p.BluRay.x264-[YTS.AM]' => {
        year: '2017',
        name: 'Justice League (2017).mp4'
      },
      'Jumanji.Welcome.To.The.Jungle.2017.1080p.WEBRip.x264-[YTS.AM]' => {
        year: '2017',
        name: 'Jumanji: Welcome to the Jungle (2017).mp4'
      },
      'The.Prestige.2006.m720p.x264' => {
        year: '2006',
        name: 'The Prestige (2006).mp4'
      },
      'Gone.in.Sixty.Seconds.2000.720p.BrRip.x264.YIFY+HI' => {
        year: '2000',
        name: 'Gone in Sixty Seconds (2000).mp4'
      },
      'Rain.Man.Br.YIFY' => {
        directory: 'Rain Man (1988)',
        year: '1988',
        name: 'Rain Man (1988).mp4'
      },
      'Stealth (2005) BDRip 720p x264-muxed' => {
        year: '2005',
        name: 'Stealth (2005).mp4'
      },
      'The.Train.Robbers.1973.720p.BluRay.x264.YIFY' => {
        year: '1973',
        name: 'The Train Robbers (1973).mp4'
      },
      'the.water.horse.720p.x264' => {
        year: '2007',
        directory: 'The Water Horse (2007)',
        name: 'The Water Horse (2007).mp4'
      }
    }

    movies.each_pair do |filename, data|
      context filename do
        before(:each) do
          dirname = MovieOrganizer.root.join('tmp', data.fetch(:directory, ''))
          @filepath = create_test_file(filename: filename, extension: 'mp4', dirname: dirname).first
          @expected_filename = data[:name]
          @expected_year = data[:year]
          tmdb_instance = Movie.match?(@filepath)
          @movie = Movie.new(@filepath, tmdb_instance)
          @movie.process!
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
            expect(@movie.year).to eq(@expected_year.to_i)
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
      let(:movie) do
        tmdb_instance = Movie.match?(filename)
        Movie.new(filename, tmdb_instance)
      end

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
          settings = Settings.instance
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
# rubocop:enable Metrics/ModuleLength
