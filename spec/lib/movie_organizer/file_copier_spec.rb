# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
module MovieOrganizer
  RSpec.describe FileCopier, type: :lib do
    let(:tmp_movie_src) { MovieOrganizer.root.join('spec', 'files', 'movies') }
    let(:tmp_dest) { MovieOrganizer.root.join('tmp', 'files', 'movies') }
    test_files = {}
    Dir[MovieOrganizer.root.join('spec', 'files', 'movies', '**', '*')].each do |src|
      next if File.directory?(src)
      dir, filename = src.split('/')[-2..999]
      dest = MovieOrganizer.root.join('tmp', 'files', 'movies').join(dir, filename)
      test_files[src] = dest.to_s
    end

    before(:each) do
      test_files.each_pair do |_src, dst|
        FileUtils.rm_rf(File.dirname(dst))
      end
    end

    context '#copy' do
      context 'with a local target' do
        test_files.each_pair do |src, dst|
          it "copies [#{src}] to [#{dst}]" do
            expect(File.exist?(dst)).to eq(false)
            file_copier = FileCopier.new(src, dst, dry_run: false)
            file_copier.copy
            expect(File.exist?(dst)).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
