require 'rails'
require 'firewool'

begin
module Firewool

  class Railtie < Rails::Railtie
    # nothing here right now
    config.to_prepare do
      # p "hook added"
      #ApplicationController.send(:extend, Firewool::Hook)
    end
  end

end
rescue
p $!, $!.message
raise $!
end