# Create a .test.env and a .development.env for your different local
# environments
require 'dotenv'
paths = %W(.env .env.#{ENV['APP_ENV']}).map { |name| "#{Dir.pwd}/#{name}" }
Dotenv.load(*paths).each { |k, v| ENV[k] = v }

require 'movie_organizer/version'

module MovieOrganizer
  def self.root
    Pathname.new(File.dirname(__FILE__)).parent
  end

  def self.current_environment
    ENV.fetch('APP_ENV', 'development')
  end
end
