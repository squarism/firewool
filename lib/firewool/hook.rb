#p "Hook loaded."

# class Module
#   def redefine_const(name, value)
#     __send__(:remove_const, name) if const_defined?(name)
#     const_set(name, value)
#   end
# end

module Firewool::Hook
  FIREWOOL_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/firewool.yml")
    
  # TODO: opinionated.  provide instructions on how to forget about this filter
  # and redirect to their own thing.  but this should redirect to the 403.html in public
  def ip_filter
    "Magic happens here in Firewool::Hook#ip_filter"
    
    # if no allowed ranges match, then deny
    # if !ip_allow?(request.remote_ip)
      # render :text => "Public Access Denied.", :status => 403
    # end
    if !ip_allow?(request.remote_ip)
      render :text => "Public Access Denied.", :status => 403
    end
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