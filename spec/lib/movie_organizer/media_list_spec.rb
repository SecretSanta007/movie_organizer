module MovieOrganizer
  RSpec.describe MediaList, type: :lib do
    include_context 'media_shared'

    let(:media_list) { MediaList.new([tmpdir]) }

    context '#new' do
      %w(m4v mov mkv mp4 avi).each do |extension|
        it "collects #{extension} files" do
          create_test_file(count: 3, extension: extension)
          expect(media_list.file_collection.count).to eq(3)
        end
      end
    end

    context '.video?' do
      it 'returns true if passed filename has a video extension' do
        expect(media_list.video?('bogus.mp4')).to eq(true)
      end

      it "returns false if passed filename isn't a video extension" do
        expect(media_list.video?('bogus.mp3')).to eq(false)
      end
    end

    context '.subtitle?' do
      it 'returns true if passed filename has a subtitle extension' do
        expect(media_list.subtitle?('bogus.sub')).to eq(true)
        expect(media_list.subtitle?('bogus.srt')).to eq(true)
      end

      it "returns false if passed filename isn't a subtitle extension" do
        expect(media_list.subtitle?('bogus.mp3')).to eq(false)
      end
    end

    context '.media?' do
      it 'returns true if passed filename has a media extension' do
        expect(media_list.media?('bogus.srt')).to eq(true)
        expect(media_list.media?('bogus.mov')).to eq(true)
        expect(media_list.media?('bogus.mp3')).to eq(false)
      end
    end
  end
end
