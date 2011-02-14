#p "Hook loaded."

module Firewool::Hook
  FIREWOOL_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/firewool.yml")
    
  def load_config
      firewool_config = "AWESOME"
  end

  def self.extended(base)
    # puts "Hook INCLUDED."
    # self.load_config
  end
  
  
  def ip_filter
    # if no allowed ranges match, then deny
    # if !ip_allow?(request.remote_ip)
      # render :text => "Public Access Denied.", :status => 403
    # end
    "Magic happens here in Firewool::Hook#ip_filter"
  end
  
  
  def ip_allow?(ip)
    if FIREWOOL_CONFIG[Rails.env]['ip_restriction']
      # get our policy from the conf file
      allowed_ranges = FIREWOOL_CONFIG[Rails.env]['allow']
      denied_ranges = FIREWOOL_CONFIG[Rails.env]['deny']

      # default allow check
      if allowed_ranges.include?("0.0.0.0")
        # default_allow makes access_decision true first
        access_decision = true
      else
        # default_allow makes access_decision true first
        access_decision = false
      end
      
      client_ip = IPAddress::parse ip
      
      
      #puts "ALLOWED RANGES: #{allowed_ranges}"
      #puts "DENIED RANGES: #{denied_ranges}"
      
      # apply allow rules
      if in_range?(allowed_ranges, client_ip)
        #puts "ALLOWED"
        access_decision = true
      end

      # apply deny rules      
      if in_range?(denied_ranges, client_ip)
        #puts "DENIED"
        access_decision = false
      end
      
      # return our shizz
      access_decision
    end
  end
  
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
  
  # def acts_as_awesome(*args)
  #   p "hook called"
  #   options = args.extract_options!
  #   include Firewool::InstanceMethods
  #   p " => instace methods added"
  #   before_filter :an_awesome_filter
  #   p " => filter added"
  # end
  
end