require 'test_helper'
require 'yaml'

class FirewoolTest < ActionController::TestCase
  tests DummyController
  
  # So rails on a before_filter uses the instance variable in requests:
  # http://guides.rubyonrails.org/action_controller_overview.html
  # So let's create an instance to test with.
  dc = DummyController.new

  # get our configuration, which we'll change later for certain tests
  conf_file = dc.class.firewool_config.yaml_config[Rails.env]
  
  # test basic module includes/extends  
  context "The controller" do
    should "respond to instance method from module" do
      assert dc.respond_to? :ip_filter
    end
  end
  
  # test reading firewool.yml config file
  context "The Firewool" do
    should "have the configuration loaded" do
      assert conf_file.key?("ip_restriction"), "Should have the ip_restriction in firewool conf file"
      assert conf_file.key?("allow"), "Should have the ip_ranges_allowed in firewool conf file"
    end
  end
  
  # test policy enforcement
  context "The Firewool" do
    should "allow valid IPs while blocking invalid IPs" do
      # this is weird that I have to reset the configuration,
      # I thought this would go in order
      conf_file["allow"] = ["192.168.0.0/16"]
      assert_equal false, dc.ip_allow?("172.168.0.1")
      assert_equal false, dc.ip_allow?("12.168.0.1")
      assert_equal false, dc.ip_allow?("0.0.0.0")
      assert_equal true, dc.ip_allow?("192.168.0.1")
    end
  end
  
  context "The Firewool" do
    should "allow valid IPs when using a default allow" do
      conf_file["allow"] = ["0.0.0.0"]
      assert_equal true, dc.ip_allow?("12.168.0.1")
    end
  end
  
  context "The Firewool" do
    should "allow and disallow correctly with a default allow" do
      conf_file["allow"] = ["0.0.0.0"]
      assert_equal true, dc.ip_allow?("12.168.0.1")
      assert_equal true, dc.ip_allow?("192.168.0.1")
      assert_equal false, dc.ip_allow?("172.16.0.1")
    end
  end
end


class FooTest < ActionController::TestCase
  tests FooController
  fc = FooController.new
  
  # conf_file = $firewool_config[Rails.env]
  conf_file = fc.class.firewool_config.yaml_config[Rails.env]
  
  # test reading firewool.yml config file
  context "The Firewool" do
    should "have the configuration loaded" do
      assert conf_file.key?("ip_restriction"), "Should have the ip_restriction in firewool conf file"
      assert conf_file.key?("allow"), "Should have the ip_ranges_allowed in firewool conf file"
    end
  end
  
  context "The Firewool" do
    should "not hit the filesystem more than once when loading the conf file" do
      assert_equal 1, fc.class.firewool_config.filesystem_hits
      fc = FooController.new
      fc = FooController.new
      assert_equal 1, fc.class.firewool_config.filesystem_hits
    end
  end
  
end