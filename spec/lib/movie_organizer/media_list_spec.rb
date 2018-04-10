# frozen_string_literal: true

require 'spec_helper'

module MovieOrganizer
  RSpec.describe MediaList, type: :lib do
    include_context 'media_shared'

    let(:media_list) { MediaList.new(Dir[file_fixture_path]) }

    context '#new' do
      it 'only collects video files' do
        good = media_list.file_collection.grep(/good/)
        expect(good.count).to eq(5)
        bad = media_list.file_collection.grep(/bad/)
        expect(bad.count).to eq(0)
      end
    end
  end
end
