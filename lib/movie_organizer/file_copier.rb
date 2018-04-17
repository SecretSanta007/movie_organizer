# frozen_string_literal: true

require 'net/scp'

module MovieOrganizer
  class FileCopier
    attr_accessor :filename, :target_file
    attr_reader :username, :hostname, :remote_filename

    def initialize(filename, target_file)
      @filename = filename
      @target_file = target_file
      @dry_run = MovieOrganizer.options[:dry_run]
      @verbose = MovieOrganizer.options[:verbose]
    end

    def copy!
      ssh? ? remote_copy : local_copy
    end

    private

    def local_copy
      dir = File.dirname(target_file)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
      if File.exist?(target_file)
        Logger.instance.info("    already exists: [#{target_file.green.bold}]")
        return true
      end
      if MovieOrganizer.options[:copy]
        FileUtils.copy(filename, target_file, noop: @dry_run, verbose: @verbose)
      else
        FileUtils.move(filename, target_file, noop: @dry_run, verbose: @verbose)
      end
    end

    def remote_copy
      parse_target
      return do_remote_dry_run if @dry_run
      create_remote_dir
      copy_file_to_remote
    end

    def do_remote_dry_run
      Logger.instance.info("Would remotely execute: [#{create_remote_dir_cmd}] on #{hostname}")
      Logger.instance.info("Would execute: [#{copy_file_to_remote_cmd}]")
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

    def create_remote_dir_cmd
      "mkdir -p \"#{target_dir}\""
    end

    def copy_file_to_remote_cmd
      "scp '#{filename}' '#{remote_filename}'"
    end

    def create_remote_dir
      Net::SSH.start(hostname, username, timeout: 5) do |ssh|
        ssh.exec!(create_remote_dir_cmd)
      end
    rescue Net::SSH::ConnectionTimeout, Errno::EHOSTUNREACH, Errno::EHOSTDOWN
      Logger.instance.error("ConnectionTimeout: the host '#{hostname}' is unreachable.".red)
    end

    def copy_file_to_remote
      Net::SCP.start(hostname, username) do |scp|
        scp.upload!(filename, remote_filename)
      end
      FileUtils.rm(filename, noop: @dry_run) unless MovieOrganizer.options[:copy]
    rescue Net::SSH::ConnectionTimeout, Errno::EHOSTUNREACH, Errno::EHOSTDOWN
      Logger.instance.error("ConnectionTimeout: the host '#{hostname}' is unreachable.".red)
    end
  end
end
