# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "witness/version"

Gem::Specification.new do |s|
  s.name        = "witness"
  s.version     = Witness::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Hoeksema"]
  s.email       = ["steve@seven.net.nz"]
  s.homepage    = "http://github.com/steveh/witness"
  s.summary     = "Witness"
  s.description = "Witness"

  s.rubyforge_project = "witness"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
  s.add_runtime_dependency(%q<sigil>, ["~> 1.0.2"])
  s.add_runtime_dependency(%q<rack>, [">= 0"])
  s.add_development_dependency(%q<rspec>, ["~> 2.1.0"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
  s.add_development_dependency(%q<rcov>, [">= 0"])
end