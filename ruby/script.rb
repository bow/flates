#!/usr/bin/env ruby

require 'optparse'

VERSION = '0.1.0'.freeze

class ArgParser

  class Args
    attr_accessor :tbd

    def initialize
      self.tbd = true
    end

    def define(parser)
      parser.banner = <<~__DESC__
        Usage: #{__FILE__} [OPTIONS]

        Script description.
      __DESC__
      parser.separator ''
      parser.separator 'Options:'

      parser.on('--tbd', 'TBD') do |value|
        self.tbd = value
      end

      parser.separator ''
      parser.separator 'Common options:'

      parser.on_tail('-h', '--help', 'Show this message') do
        puts parser
        exit
      end

      parser.on_tail('-v', '--version', 'Show version') do
        puts VERSION
        exit
      end
    end

    def require(key, msg)
      return unless send(key).nil?

      $stderr.puts "Error: #{msg}"
      exit 1
    end

    def require_env(key)
      val = ENV[key]
      if val.nil?
        $stderr.puts "Error: required environment variable #{key} undefined"
        exit 1
      end
      val
    end
  end

  def parse(raw_args)
    @args = Args.new
    @parser = OptionParser.new do |parser|
      @args.define(parser)
      parser.parse!(raw_args)
    end
    @args
  end
end

def main(url:, token:, group_id:, output:)
  $stderr.puts "unimplemented"
end

if __FILE__ == $PROGRAM_NAME
  parser = ArgParser.new
  args = parser.parse(ARGV)
  main()
end
