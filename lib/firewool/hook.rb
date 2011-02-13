p "Hook loaded."

module Firewool::Hook
  FIREWOOL_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/firewool_config.yml")
    
  def load_config
      firewool_config = "AWESOME"
  end

  def self.extended(base)
    puts "Hook INCLUDED."
    # self.load_config
  end
  
  
  def ip_filter
    "Magic happens here in Firewool::Hook#ip_filter"
  end
  
  # def acts_as_awesome(*args)
  #   p "hook called"
  #   options = args.extract_options!
  #   include Firewool::InstanceMethods
  #   p " => instace methods added"
  #   before_filter :an_awesome_filter
  #   p " => filter added"
  # end
  
end