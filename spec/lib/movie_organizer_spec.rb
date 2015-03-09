require 'spec_helper'

RSpec.describe MovieOrganizer, type: :module do
  context '#root' do
    it 'returns a Pathname instance' do
      expect(MovieOrganizer.root).to be_a(Pathname)
    end

    it 'returns the root directory' do
      dir = MovieOrganizer.root
      expect(dir.to_s).to match(/movie_organizer$/)
      expect(File.exist?(dir)).to eq(true)
    end
  end

  context '#current_environment' do
    it "defaults to 'development'" do
      ENV.delete('APP_ENV')
      expect(MovieOrganizer.current_environment).to eq('development')
    end

    it 'returns the APP_ENV variable' do
      ENV['APP_ENV'] = 'asdf'
      expect(MovieOrganizer.current_environment).to eq('asdf')
    end
  end

  context '#source_directories' do
    it 'raises an error if not configured' do
      ENV['MO_SOURCE_DIRS'] = nil
      expect do
        MovieOrganizer.source_directories
      end.to raise_error(KeyError)
    end

    it 'returns an array' do
      ENV['MO_SOURCE_DIRS'] = '/tmp /public'
      expect(MovieOrganizer.source_directories).to be_a(Array)
    end
  end

  context '#config_file' do
    it 'returns the default config file' do
      expect(MovieOrganizer.config_file).to match(/.movie_organizer.yml$/)
    end

    it 'ensures the file exists' do
      expect(File.exist?(MovieOrganizer.config_file)).to eq(true)
    end
  end
end
