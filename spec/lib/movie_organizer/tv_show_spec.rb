module MovieOrganizer
  RSpec.describe TvShow, type: :lib do
    include_context 'media_shared'

    let(:filename) { 'The.Walking.Dead.S05E02.720p.HDTV.x264-KILLERS' }
    let(:files) { create_test_file('mkv', filename: filename) }
    let(:tv_show) { TvShow.new("#{filename}.mkv") }

    context '#new' do
      it 'is a child of Media' do
        expect(tv_show).to be_a(TvShow)
      end
    end

    context '.processed_filename' do
      it 'correctly processes the filename' do
        expect(tv_show.processed_filename).to eq('The Walking Dead - S05E02.mkv')
      end
    end

    context '.process!' do
      it 'moves the file to the configured location' do
        tv_show.process!
      end
    end
  end
end
