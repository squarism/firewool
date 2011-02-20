require 'active_support/core_ext'
require 'ipaddress'

# rails engine setup
require File.join(File.dirname(__FILE__), "firewool/railtie.rb")

module Firewool
  
  def self.included(base)
    base.extend(Firewool::Hook)
  end
  
  class Config
    attr_reader :yaml_config
    
    # TODO: Ugh, globals?  Really?  How can I cache the config in case someone
    # has a million controllers that include Firewool?  This gets hit every include Module.
    def initialize
      if $firewool_config.nil?
        @yaml_config = YAML.load_file("#{Rails.root.to_s}/config/firewool.yml")
        $firewool_config = @yaml_config
      end      
    end
  end

  autoload :Hook, File.join(File.dirname(__FILE__), "firewool/hook")
  autoload :InstanceMethods, File.join(File.dirname(__FILE__), "firewool/instance_methods")
end
