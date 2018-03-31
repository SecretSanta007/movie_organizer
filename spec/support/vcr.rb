# frozen_string_literal: true

require 'vcr'

# WebMock.allow_net_connect!

VCR.configure do |c|
  c.cassette_library_dir = MovieOrganizer.root.join('spec', 'fixtures', 'vcr_cassettes')
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
  # c.default_cassette_options = { record: :once }
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  c.ignore_localhost         = true
  c.debug_logger             = File.open(File.join('tmp', 'vcr.log'), 'w+')
  # config.debug_logger = $stderr
end
