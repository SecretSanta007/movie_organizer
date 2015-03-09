module MovieOrganizer
  RSpec.describe Media, type: :lib do
    include_context 'media_shared'

    let(:files) { create_test_file('mkv', count: 1, tvshow: true) }
    let(:filename) { files.first }

    context '.subtype' do
      it 'returns a TvShow' do
        expect(Media.subtype(filename)).to be_a(TvShow)
      end
    end

    context '.resolution' do
      it 'returns the video height' do
        filename = 'The.Walking.Dead.S04E08.HDTV.x264-2HD.mp4'
        filedir = File.join(MovieOrganizer.root, 'spec/files')
        media = Media.subtype(File.join(filedir, filename))
        expect(media.resolution).to eq(352)
      end
    end
  end
end
