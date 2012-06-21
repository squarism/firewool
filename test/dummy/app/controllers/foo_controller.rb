# intentionally not including Firewool, test including from ApplicationController instead

class FooController < ApplicationController
  include Firewool
  acts_as_firewalled
  before_filter :ip_filter

  def index
    render :text => "This is the index method on FooController"
  end
end
