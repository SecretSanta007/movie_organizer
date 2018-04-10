# frozen_string_literal: true

require 'singleton'

module MovieOrganizer
  class Options
    include Singleton

    def [](key)
      @@_options[key]
    end

    def hash
      @@_options
    end

    private

    def initialize_hash(hash)
      @@_options = hash
    end
  end
end
