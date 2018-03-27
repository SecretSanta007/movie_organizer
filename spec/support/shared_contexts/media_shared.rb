# frozen_string_literal: true

require 'faker'
require 'titleize'

# rubocop:disable Metrics/BlockLength
shared_context 'media_shared' do
  let(:tmpdir) { File.join(MovieOrganizer.root, 'tmp') }
  let(:default_options) { { dry_run: true, verbose: true } }

  after(:each) do
    FileUtils.rm_rf(Dir.glob("#{tmpdir}/*"))
  end

  def random_season_episode_string
    season = (1..12).to_a.sample.to_s.rjust(2, '0')
    episode = (1..33).to_a.sample.to_s.rjust(2, '0')
    "S#{season}E#{episode}"
  end

  # The.Walking.Dead.S05E02.720p.HDTV.x264-KILLERS
  def fake_movie_name(extension, tvshow = true)
    if tvshow
      filename = "#{Faker::App.name}.#{random_season_episode_string}.#{extension}"
    else
      filename = "#{Faker::Hacker.verb.titleize} #{Faker::App.name}.#{extension}"
    end
    File.join(tmpdir, filename)
  end

  def create_test_file(options = {})
    tvshow    = options.fetch(:tvshow, true)
    count     = options.fetch(:count, 1)
    filename  = options.fetch(:filename, false)
    dirname   = options.fetch(:dirname, tmpdir)
    extension = options.fetch(:extension, 'mp4')
    files     = []

    if filename
      files = [File.join(dirname, "#{filename}.#{extension}")]
      FileUtils.mkdir_p(dirname)
      File.open(files.last, 'w') { |f| f.write("Fake Media File\n") }
    else
      count.times do
        files << fake_movie_name(extension, tvshow)
        File.open(files.last, 'w') { |f| f.write("Fake Media File\n") }
      end
    end
    files
  end
end
# rubocop:enable Metrics/BlockLength
