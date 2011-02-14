class DummyController < ApplicationController
  include Firewool
  before_filter :ip_filter
end
