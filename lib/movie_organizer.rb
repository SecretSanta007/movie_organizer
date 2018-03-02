# frozen_string_literal: true

# Create a .test.env and a .development.env for your different local
# environments
require 'colored'
require 'readline'
require 'fileutils'

require 'movie_organizer/version'

module MovieOrganizer
  def self.root
    Pathname.new(File.dirname(__FILE__)).parent
  end

  def self.current_environment
    ENV.fetch('APP_ENV', 'development')
  end

  def self.config_file(filename = '.movie_organizer.yml')
    return root.join('spec', 'fixtures', filename) if current_environment == 'test'
    #:nocov:
    home = ENV.fetch('HOME')
    file = ENV.fetch('MO_CONFIG_FILE', File.join(home, '.movie_organizer.yml'))
    FileUtils.touch(file)
    file
    #:nocov:
  end

  def self.source_directories(settings = Settings.new, test_response = nil)
    settings[:new_media_directories] || begin
      strings = prompt_for('Media source directories (separated by a colon)', test_response)
      settings[:new_media_directories] = strings.split(':')
      settings.save
      settings[:new_media_directories]
    end
  end

  #:nocov:
  def self.prompt_for(message = '', test_response = nil)
    prompt = "#{message.dup}\n? "
    return test_response if test_response
    Readline.readline(prompt, true).squeeze(' ').strip
  end
  #:nocov:

  autoload :FileCopier, 'movie_organizer/file_copier'
  autoload :Logger,     'movie_organizer/logger'
  autoload :Media,      'movie_organizer/media'
  autoload :MediaList,  'movie_organizer/media_list'
  autoload :Movie,      'movie_organizer/movie'
  autoload :Organizer,  'movie_organizer/organizer'
  autoload :Settings,   'movie_organizer/settings'
  autoload :TvShow,     'movie_organizer/tv_show'
  autoload :Video,      'movie_organizer/video'
end
