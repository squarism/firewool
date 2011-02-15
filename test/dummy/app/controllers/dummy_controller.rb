class DummyController < ApplicationController
  include Firewool
  acts_as_firewalled
  before_filter :ip_filter
end
