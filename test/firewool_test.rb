require 'test_helper'

class FirewoolIntegrationTest < ActionController::TestCase
  tests DummyController
 
  context "The controller" do
    should "respond to #bar" do
      assert @controller.respond_to? :bar
    end
  end
  
  context "The controller" do
    should "return Foo#bar method ..." do
      assert_equal "Foo#bar method ...", @controller.bar
    end
  end
  
  context "The controller" do
    should "reponse to #baz" do
      assert DummyController.respond_to? :baz
    end
  end
   
end
