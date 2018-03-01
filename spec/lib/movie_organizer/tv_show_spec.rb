# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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
      file = File.join(MovieOrganizer.root, 'spec', 'support', 'filename_mappings.yml')

      context 'correctly maps the following with preserve_episode_name == false' do
        mapped = YAML.load_file(file)['tvshows_no_preserve']
        mapped.each do |from, to|
          it "maps '#{from}' to [#{to}]" do
            tv_show = TvShow.new(
              from,
              default_options.merge(preserve_episode_name: false)
            )
            expect(
              tv_show.processed_filename
            ).to eq(to)
          end
        end
      end

      context 'correctly maps the following with preserve_episode_name == true' do
        mapped = YAML.load_file(file)['tvshows_preserve']
        mapped.each do |from, to|
          it "maps '#{from}' to [#{to}]" do
            tv_show = TvShow.new(
              from,
              default_options.merge(preserve_episode_name: true)
            )
            expect(
              tv_show.processed_filename
            ).to eq(to)
          end
        end
      end
    end

    context '.process!' do
      it 'moves the file to the configured location' do
        settings = Settings.new
        binding.pry if settings.nil?
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
# rubocop:enable Metrics/BlockLength
