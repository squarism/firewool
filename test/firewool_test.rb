require 'test_helper'
require 'yaml'

class FirewoolTest < ActionController::TestCase
  #tests DummyController
 
  conf_file = DummyController::Hook::FIREWOOL_CONFIG[Rails.env]
  
  t_obj = { "ip_restriction" => "true", "allow" => ["0.0.0.0"], "deny" => ["13.13.13.13"] }
  default_allow_conf_file = YAML::dump( t_obj )
  
  context "The controller" do
    should "respond to method from Hook module" do
      assert DummyController.respond_to? :ip_filter
    end
  end
  
  context "The Firewool" do
    should "have the configuration loaded" do
      assert conf_file.key?("ip_restriction"), "Should have the ip_restriction in firewool conf file"
      assert conf_file.key?("allow"), "Should have the ip_ranges_allowed in firewool conf file"
    end
  end
  
  context "The Firewool" do
    should "allow valid IPs" do
      assert_equal true, DummyController.ip_allow?("192.168.0.1")
    end
  end

  context "The Firewool" do
    should "block invalid IPs" do
      # reset the test, this is weird, I thought this would go in order
      DummyController::Hook::FIREWOOL_CONFIG[Rails.env]["allow"] = ["192.168.0.0/16"]
      assert_equal false, DummyController.ip_allow?("172.168.0.1")
      assert_equal false, DummyController.ip_allow?("12.168.0.1")
      assert_equal false, DummyController.ip_allow?("0.0.0.0")
    end
  end
  
  context "The Firewool" do
    puts DummyController::Hook::FIREWOOL_CONFIG[Rails.env]
    should "allow valid IPs when using a default allow" do
      DummyController::Hook::FIREWOOL_CONFIG[Rails.env]["allow"] = ["0.0.0.0"]
      puts DummyController::Hook::FIREWOOL_CONFIG[Rails.env]
      assert_equal DummyController.ip_allow?("12.168.0.1"), true
    end
  end
       
end
