require 'test_helper'

class FirewoolIntegrationTest < ActionController::TestCase
  #tests DummyController
 
  context "The controller" do
    should "respond to method from Hook module" do
      assert DummyController.respond_to? :ip_filter
    end
  end
  
  context "The Firewool class" do
    conf_file = DummyController::Hook::FIREWOOL_CONFIG[Rails.env]
    
    should "have the configuration loaded" do
      assert conf_file.key?("ip_restriction"), "Should have the ip_restriction in firewool conf file"
      assert conf_file.key?("ip_ranges_allowed"), "Should have the ip_ranges_allowed in firewool conf file"
    end
  end
     
end
