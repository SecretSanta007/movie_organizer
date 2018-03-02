# frozen_string_literal: true

module MovieOrganizer
  class FileCopier
    attr_accessor :filename, :target_file, :options
    attr_reader :username, :hostname, :remote_filename

    def initialize(filename, target_file, options)
      @filename = filename
      @target_file = target_file
      @options = options
    end

    def copy
      ssh? ? remote_copy : local_copy
    end

    private

    def local_copy
      FileUtils.mkdir_p(File.dirname(target_file))
      FileUtils.copy(
        filename,
        target_file,
        noop: options[:dry_run]
      )
    end

    def remote_copy
      parse_target
      return do_dry_run if options[:dry_run]
      Net::SSH.start(hostname, username) do |ssh|
        ssh.exec("mkdir -p '#{target_dir}'")
      end
      Net::SCP.start(hostname, username) do |scp|
        scp.upload!(filename, remote_filename)
      end
    end

    def do_dry_run
      puts("Would remotely execute: [#{"mkdir -p '#{target_dir}'"}] on #{hostname}")
      puts("Would execute: [#{"scp '#{filename}' '#{remote_filename}'"}]")
    end

    def target_dir
      @target_dir ||= begin
        parts = @remote_filename.split('/')
        parts[0..parts.length - 2].join('/').to_s
      end
    end

    def parse_target
      return nil if @parse_target
      @parse_target = true
      temp ||= target_file.to_s.split('/')[2..99]
      md = temp.join('/').match(/([\w\-\.]+)@([^\/]+)(\/.+)$/)
      @username = md[1]
      @hostname = md[2]
      @remote_filename = md[3]
      if @username.nil? || @hostname.nil? || @remote_filename.nil?
        raise 'SSH path not formatted properly. Use [ssh://username@hostname/absolute/path]'
      end
    end

    def ssh?
      target_file.match?(/^ssh:/)
    end
  end
end
