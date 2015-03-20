module MovieOrganizer
  RSpec.describe TvShow, type: :lib do
    include_context 'media_shared'

    let(:filename) do
      create_test_file(
        filename: 'The.Walking.Dead.S05E02.720p.HDTV.x264-KILLERS',
        extension: 'mkv'
      ).first
    end
    let(:tv_show) { TvShow.new(filename, default_options) }

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
      context 'The.Walking.Dead.S05E02.720p.HDTV.x264-KILLERS.mp4' do
        it 'correctly processes the filename' do
          filename = 'The.Walking.Dead.S05E02.720p.HDTV.x264-KILLERS.mp4'
          tv_show = TvShow.new(filename, default_options)
          expect(
            tv_show.processed_filename
          ).to eq('The Walking Dead - S05E02.mp4')
        end
      end

      context 'arrow.316.hdtv-lol.mp4' do
        it 'correctly processes the filename' do
          filename = 'arrow.316.hdtv-lol.mp4'
          tv_show = TvShow.new(filename, default_options)
          expect(
            tv_show.processed_filename
          ).to eq('Arrow - S03E16.mp4')
        end
      end

      context 'Star Trek - 1x01 - The Man Trap.mp4' do
        it 'correctly processes the filename' do
          filename = 'Star Trek - 1x01 - The Man Trap.mp4'
          tv_show = TvShow.new(filename, default_options)
          expect(
            tv_show.processed_filename
          ).to eq('Star Trek - S01E01 - The Man Trap.mp4')
        end
      end

      context 'the.flash.2014.115.hdtv-lol.mp4' do
        it 'correctly processes the filename' do
          filename = 'the.flash.2014.115.hdtv-lol.mp4'
          tv_show = TvShow.new(filename, default_options)
          expect(
            tv_show.processed_filename
          ).to eq('The Flash 2014 - S01E15.mp4')
        end
      end

      it 'ignores sample files' do
        filename = 'arrow.316.hdtv-lol.sample.mp4'
        tv_show = TvShow.new(filename, default_options)
        expect(
          tv_show.processed_filename
        ).to eq(nil)
      end
    end

    context '.process!' do
      it 'moves the file to the configured location' do
        settings = Settings.new
        target_dir = File.join(
          settings[:tv_shows][:directory],
          tv_show.title,
          "Season #{tv_show.season.sub(/^0+/, '')}"
        )
        expect(FileUtils).to receive(:mkdir_p).with(target_dir, noop: true).and_return(nil)
        expect(FileUtils).to receive(:move).and_return(nil)
        tv_show.process!
      end
    end
  end
end
