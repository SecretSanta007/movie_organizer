# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
module MovieOrganizer
  RSpec.describe Video, type: :lib do
    include_context 'media_shared'

    let(:filename) do
      create_test_file(
        filename: 'Vacation in Florida',
        extension: 'mp4'
      ).first
    end
    let(:video) { Video.new(filename) }

    context '#new' do
      it 'returns a child of the Media class' do
        expect(video).to be_a(Medium)
      end

      it 'is a Video' do
        expect(video).to be_a(Video)
      end

      it 'sets filename accessor' do
        expect(video.filename).to eq(filename)
      end
    end

    context '.processed_filename' do
      it 'returns a string' do
        expect(video.processed_filename).to be_a(String)
      end
    end

    context '.process!' do
      it 'moves the file to the configured location' do
        fc = FileCopier.new('/tmp/bogus', '/tmp/bogus2')
        expect(fc).to receive(:copy!).and_return(nil)
        video.process!(fc)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
