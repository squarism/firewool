require 'active_support/core_ext'
require 'ipaddress'
require 'singleton'

# rails engine setup
require File.join(File.dirname(__FILE__), "firewool/railtie.rb")

module Firewool

  def self.included(base)
    base.extend(Firewool::Hook)
  end

  class Config
    include Singleton
    attr_reader :yaml_config
    attr_accessor :filesystem_hits  # track how many times we read the yml

    def load_config
      @filesystem_hits += 1
      YAML.load_file("#{Rails.root.to_s}/config/firewool.yml")
    end

    def yaml_config
      @@yaml_config ||= self.load_config
    end

    def initialize
      @filesystem_hits = 0
    end
  end

  autoload :Hook, File.join(File.dirname(__FILE__), "firewool/hook")
  autoload :InstanceMethods, File.join(File.dirname(__FILE__), "firewool/instance_methods")
end
