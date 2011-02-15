require 'active_support/core_ext'
require 'ipaddress'

# p "loading main"
require File.join(File.dirname(__FILE__), "firewool/railtie.rb")

module Firewool
  
  def self.included(base)
    base.extend(ClassMethods)
    # puts "RESPOND TO: #{base.respond_to?(:firewool_config)}"
    # puts "RESPOND TO: #{base.respond_to?(:bar)}"
    # puts "RESPOND TO: #{base.respond_to?(:bleep)}"
    # n = base.new
    # puts n
    # puts "RESPOND TO: #{n.respond_to?(:bar)}"
  end
  
  class Config
    attr_reader :yaml_config
    
    def initialize
      @yaml_config = YAML.load_file("#{Rails.root.to_s}/config/firewool.yml")
    end
  end
  
  module ClassMethods
    def acts_as_firewalled
      @firewool_config = Firewool::Config.new
      include Firewool::InstanceMethods
    end

    def firewool_config
      @firewool_config.yaml_config || self.superclass.instance_variable_get('@firewool_config').yaml_config
    end

    def bar
      puts "Firewool#bar method ..."
    end
  end
    
  module InstanceMethods
    # TODO: opinionated.  provide instructions on how to forget about this filter
    # and redirect to their own thing.  but this should redirect to the 403.html in public
    def ip_filter
      "Magic happens here in Firewool::Hook#ip_filter"

      # if no allowed ranges match, then deny
      # if !ip_allow?(request.remote_ip)
        # render :text => "Public Access Denied.", :status => 403
      # end

      puts "REQUEST OBJECT: #{request}"
      #puts "REQUEST.ENV: #{@request.env['HTTP_X_FORWARDED_FOR']}"
      # puts "REMOTE IP: #{request.remote_ip}"
      # puts "REMOTE_ADDR: #{request.env['REMOTE_ADDR']}"

      #if !ip_allow?(request.remote_ip)
      #  render :text => "Public Access Denied.", :status => 403
      #end
    end

    def ip_allow?(ip)
      firewool_config = self.class.firewool_config[Rails.env]
      
      # if FIREWOOL_CONFIG[Rails.env]['ip_restriction']
      if firewool_config['ip_restriction']
        # get our policy from the conf file
        allowed_ranges = firewool_config['allow']
        denied_ranges = firewool_config['deny']

        # default allow check
        if allowed_ranges.include?("0.0.0.0")
          # default_allow makes access_decision true first
          access_decision = true
        else
          # default_allow makes access_decision false first
          access_decision = false
        end

        client_ip = IPAddress::parse ip

        puts "ALLOWED RANGES: #{allowed_ranges}"
        puts "DENIED RANGES: #{denied_ranges}"

        # apply allow rules
        if !allowed_ranges.nil?
          if in_range?(allowed_ranges, client_ip)
            #puts "ALLOWED"
            access_decision = true
          end
        end

        # apply deny rules      
        if !denied_ranges.nil?
          if in_range?(denied_ranges, client_ip)
            #puts "DENIED"
            access_decision = false
          end
        end

        # return our shizz
        access_decision
      end
    end

    #-----------------------------------------------------------------------------------------------
    private
    def in_range?(range, ip)
      range.each do |r|
        range_ip = IPAddress::parse r
        if range_ip.include? ip
          return true
        end
      end
      return false
    end
  end

  # autoload :Hook, File.join(File.dirname(__FILE__), "firewool/hook")
  # autoload :Baz, File.join(File.dirname(__FILE__), "foo/baz")
  # autoload :InstanceMethods, File.join(File.dirname(__FILE__), "foo/instance_methods")
end
