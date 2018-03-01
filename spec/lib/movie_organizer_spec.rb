# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
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
    before do
      @original_env = ENV['APP_ENV']
    end

    after do
      ENV['APP_ENV'] = @original_env
    end

    it "defaults to 'development'" do
      ENV.delete('APP_ENV')
      expect(MovieOrganizer.current_environment).to eq('development')
    end

    it 'returns the APP_ENV variable' do
      ENV['APP_ENV'] = 'asdf'
      expect(MovieOrganizer.current_environment).to eq('asdf')
    end
  end

  context '#config_file' do
    it 'returns the default config file' do
      expect(MovieOrganizer.config_file.to_s).to match(/.movie_organizer.yml$/)
    end

    it 'ensures the file exists' do
      expect(File.exist?(MovieOrganizer.config_file)).to eq(true)
    end
  end
end
# rubocop:enable Metrics/BlockLength
