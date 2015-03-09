module MovieOrganizer
  RSpec.describe Media, type: :lib do
    include_context 'media_shared'

    context '.subtype' do
      it 'returns a TvShow' do
        filename = create_test_file(
          filename: 'The.Walking.Dead.S04E08.HDTV.x264-2HD',
          extension: 'mp4'
        ).first
        expect(Media.subtype(filename)).to be_a(TvShow)
      end

      it 'returns a Movie' do
        filename = create_test_file(
          filename: 'Beetlejuice', extension: 'mp4'
        ).first
        expect(Media.subtype(filename)).to be_a(Movie)
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
