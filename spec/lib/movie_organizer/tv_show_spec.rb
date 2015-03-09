module MovieOrganizer
  RSpec.describe TvShow, type: :lib do
    include_context 'media_shared'

    let(:filename) do
      create_test_file(
        filename: 'The.Walking.Dead.S05E02.720p.HDTV.x264-KILLERS',
        extension: 'mkv'
      ).first
    end
    let(:tv_show) { TvShow.new(filename) }

    context '#new' do
      it 'returns a child of the Media class' do
        expect(tv_show).to be_a(Media)
      end

      it 'is a TvShow' do
        expect(tv_show).to be_a(TvShow)
      end

      it 'sets filename accessor' do
        expect(tv_show.filename).to eq(filename)
      end
    end

    context '.processed_filename' do
      it 'correctly processes the filename' do
        expect(
          tv_show.processed_filename
        ).to eq('The Walking Dead - S05E02.mkv')
      end
    end

    context '.process!' do
      it 'moves the file to the configured location' do
        settings = Settings.new
        target_dir = File.join(
          settings[:tv_shows][:directory],
          tv_show.title,
          "Season #{tv_show.season}"
        )
        expect(FileUtils).to receive(:mkdir_p).with(target_dir).and_return(nil)
        expect(FileUtils).to receive(:move).and_return(nil)
        tv_show.process!
      end
    end
  end
end
