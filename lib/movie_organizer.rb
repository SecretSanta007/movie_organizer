# Create a .test.env and a .development.env for your different local
# environments
require 'dotenv'
paths = %W(.env .env.#{ENV['APP_ENV']}).map { |name| "#{Dir.pwd}/#{name}" }
Dotenv.load(*paths).each { |k, v| ENV[k] = v }

require 'movie_organizer/version'
require 'midwire_common/yaml_setting'

module MovieOrganizer
  def self.root
    Pathname.new(File.dirname(__FILE__)).parent
  end

  def self.current_environment
    ENV.fetch('APP_ENV', 'development')
  end

  def self.source_directories
    dirs = ENV.fetch('MO_SOURCE_DIRS')
    dirs.split
  end

  # If you don't have a HOME directory defined, you are on an OS that is
  # retarded, and this call will fail.
  def self.config_file
    home = ENV.fetch('HOME')
    file = ENV.fetch('MO_CONFIG_FILE', File.join(home, '.movie_organizer.yml'))
    FileUtils.mkdir_p(File.dirname(file))
    FileUtils.touch(file)
    file
  end

  autoload :Logger,    'movie_organizer/logger'
  autoload :Media,     'movie_organizer/media'
  autoload :MediaList, 'movie_organizer/media_list'
  autoload :Organizer, 'movie_organizer/organizer'
  autoload :Settings,  'movie_organizer/settings'
  autoload :TvShow,    'movie_organizer/tv_show'
end
