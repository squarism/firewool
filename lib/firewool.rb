require 'active_support/core_ext'
#require 'ipaddress'

p "loading main"

require File.join(File.dirname(__FILE__), "firewool/railtie.rb")

module Firewool
    
  def bar
    "Firewool#bar method ..."
  end

  autoload :Hook, File.join(File.dirname(__FILE__), "firewool/hook")
  # autoload :Baz, File.join(File.dirname(__FILE__), "foo/baz")
  # autoload :InstanceMethods, File.join(File.dirname(__FILE__), "foo/instance_methods")
  
end
