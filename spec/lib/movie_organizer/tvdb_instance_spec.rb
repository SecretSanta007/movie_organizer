# frozen_string_literal: true

module MovieOrganizer
  RSpec.describe TvdbInstance, type: :lib, vcr: true do
    context '#tv_show?' do
      it 'returns false if the title is not found' do
        instance = TvdbInstance.new('unknown tv show')
        expect(instance.tv_show?).to eq(false)
      end

      it 'returns self if the title is found' do
        instance = TvdbInstance.new('the walking dead')
        expect(instance.tv_show?).to eq(instance)
      end
    end
  end
end
