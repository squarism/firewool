# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "firewool/version"

Gem::Specification.new do |s|
  s.name        = "firewool"
  s.version     = Firewool::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Dillon"]
  s.email       = ["squarism@gmail.com"]
  s.homepage    = "http://github.com/squarism/firewool"
  s.summary     = %q{Firewool is an IP firewall for rails 3.  Baa.}
  s.description = %q{Firewool blocks and allows IPs to your controller actions.}

  s.rubyforge_project = "firewool"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('ipaddress', '>= 0.7.0')
  s.add_development_dependency('shoulda')
end
