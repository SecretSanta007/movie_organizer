# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
module MovieOrganizer
  RSpec.describe Movie, type: :lib do
    include_context 'media_shared'

    let(:filename) do
      create_test_file(
        filename: 'Foreign+Correspondent+(1940)+1080p', extension: 'mp4'
      ).first
    end
    let(:movie) { Movie.new(filename, default_options) }

    context '#new' do
      it 'returns a child of the Media class' do
        expect(movie).to be_a(Media)
      end

      it 'is a Movie' do
        expect(movie).to be_a(Movie)
      end

      it 'sets filename accessor' do
        expect(movie.filename).to eq(filename)
      end
    end

    context '.processed_filename' do
      it 'correctly processes the filename' do
        expect(
          movie.processed_filename
        ).to eq('Foreign Correspondent (1940).mp4')
      end
    end

    context '.year' do
      it 'returns the year' do
        expect(movie.year).to eq('1940')
      end
    end

    context '.process!' do
      it 'moves the file to the configured location' do
        settings = Settings.new
        target_dir = File.join(
          settings[:movies][:directory], "#{movie.title} (#{movie.year})"
        )
        expect(FileUtils).to receive(:mkdir_p).with(target_dir, noop: true).and_return(nil)
        expect(FileUtils).to receive(:move).and_return(nil)
        movie.process!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
