p "Hook loaded."

module Firewool::Hook
  
  def baz
    "Firewool::Hook#baz"
  end
  
  # def acts_as_awesome(*args)
  #   p "hook called"
  #   options = args.extract_options!
  #   include Firewool::InstanceMethods
  #   p " => instace methods added"
  #   before_filter :an_awesome_filter
  #   p " => filter added"
  # end
  
end