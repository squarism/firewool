require 'test_helper'

class FirewoolIntegrationTest < ActionController::TestCase
  tests DummyController
 
  context "The controller" do
    should "respond to method from Hook module" do
      assert DummyController.respond_to? :ip_filter
    end
  end
     
end
