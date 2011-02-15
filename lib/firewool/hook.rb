module Firewool
  module Hook
    def acts_as_firewalled
      @firewool_config = Firewool::Config.new
      include Firewool::InstanceMethods
    end

    def firewool_config
      @firewool_config.yaml_config || self.superclass.instance_variable_get('@firewool_config').yaml_config
    end
  end
end