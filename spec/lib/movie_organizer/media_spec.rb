module MovieOrganizer
  RSpec.describe Media, type: :lib do
    include_context 'media_shared'

    context '.subtype' do
      it 'returns a TvShow with S&E syntax: SnnEnn' do
        filename = create_test_file(
          filename: 'The.Walking.Dead.S04E08.HDTV.x264-2HD',
          extension: 'mp4'
        ).first
        expect(Media.subtype(filename, default_options)).to be_a(TvShow)
      end

      it 'returns a TvShow with S&E syntax: nxn' do
        filename = create_test_file(
          filename: 'The.Walking.Dead.4x0.HDTV.x264-2HD',
          extension: 'mp4'
        ).first
        expect(Media.subtype(filename, default_options)).to be_a(TvShow)
      end

      it 'returns a TvShow with S&E syntax: nnxn' do
        filename = create_test_file(
          filename: 'The.Walking.Dead.12x8.HDTV.x264-2HD',
          extension: 'mp4'
        ).first
        expect(Media.subtype(filename, default_options)).to be_a(TvShow)
      end

      it 'returns a TvShow with S&E syntax: nnxnn' do
        filename = create_test_file(
          filename: 'The.Walking.Dead.12x08.HDTV.x264-2HD',
          extension: 'mp4'
        ).first
        expect(Media.subtype(filename, default_options)).to be_a(TvShow)
      end

      it 'returns a TvShow with S&E syntax: nxnn' do
        filename = create_test_file(
          filename: 'The.Walking.Dead.2x18.HDTV.x264-2HD',
          extension: 'mp4'
        ).first
        expect(Media.subtype(filename, default_options)).to be_a(TvShow)
      end

      it 'returns a Movie' do
        filename = create_test_file(
          filename: 'Beetlejuice', extension: 'mp4'
        ).first
        expect(Media.subtype(filename, default_options)).to be_a(Movie)
      end
    end

    context '.resolution' do
      it 'returns the video height' do
        filename = 'The.Walking.Dead.S04E08.HDTV.x264-2HD.mp4'
        filedir = File.join(MovieOrganizer.root, 'spec/files')
        media = Media.subtype(File.join(filedir, filename), default_options)
        expect(media.resolution).to eq(352)
      end
    end
  end
end
