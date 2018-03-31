# frozen_string_literal: true

module MovieOrganizer
  # rubocop:disable Metrics/BlockLength
  RSpec.describe TmdbInstance, type: :lib, vcr: true do
    context '#movie?' do
      it 'returns false if the title is not found' do
        instance = TmdbInstance.new('unknown tv show')
        expect(instance.movie?).to eq(false)
      end

      it 'returns self if the title is found' do
        instance = TmdbInstance.new('the matrix', 1999)
        expect(instance.movie?).to eq(instance)
      end
    end

    context '#likely_match' do
      context 'when passing a year' do
        it 'returns the first match with a release date matching the year' do
          instance = TmdbInstance.new('star wars', 2015)
          instance.movie?
          match = instance.likely_match
          expect(match.title).to eq('Star Wars: The Force Awakens')
        end
      end

      context 'when not passing a year' do
        it 'returns the first match' do
          instance = TmdbInstance.new('star wars')
          instance.movie?
          match = instance.likely_match
          expect(match.title).to eq('Star Wars')
        end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
