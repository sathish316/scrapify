# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "apify/version"

Gem::Specification.new do |s|
  s.name        = "apify"
  s.version     = Apify::VERSION
  s.authors     = ["Sathish & Shakiel"]
  s.email       = ["sathish316@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Apify converts static html sites to RESTlike APIs}
  s.description = %q{Apify converts static html sites to RESTlike APIs}

  s.rubyforge_project = "apify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
