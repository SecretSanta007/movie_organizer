# frozen_string_literal: true

module MovieOrganizer
  class FileCopier
    attr_accessor :filename, :target_file, :options
    attr_reader :username, :hostname, :remote_filename

    def initialize(filename, target_file, options)
      @filename = filename
      @target_file = target_file
      @options = options
      parse_target
    end

    def copy
      if ssh?
        remote_copy
      else
        local_copy
      end
    end

    private

    def remote_copy
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
      temp ||= target_file.split('/')[2..99]
      md = temp.join('/').match(/([\w\-\.]+)@([^\/]+)(\/.+)$/)
      @username = md[1]
      @hostname = md[2]
      @remote_filename = md[3]
      if @username.nil? || @hostname.nil? || @remote_filename.nil?
        raise 'SSH path not formatted properly. Use [ssh://username@hostname/absolute/path]'
      end
    end

    def local_copy
      FileUtils.move(
        filename,
        target_file,
        force: true, noop: options[:dry_run]
      )
    end

    def ssh?
      target_file.match?(/^ssh:/)
    end
  end
end
