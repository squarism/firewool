module Firewool
  module Hook
    def acts_as_firewalled
      @firewool_config = Firewool::Config.instance
      include Firewool::InstanceMethods
    end

    def firewool_config
      @firewool_config
    end
  end
end