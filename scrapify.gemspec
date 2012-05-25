# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scrapify/version"

Gem::Specification.new do |s|
  s.name        = "scrapify"
  s.version     = Scrapify::VERSION
  s.authors     = ["Sathish & Shakiel"]
  s.email       = ["sathish316@gmail.com"]
  s.homepage    = "http://www.github.com/sathish316/scrapify"
  s.summary     = %q{ScrApify scraps static html sites to scraESTlike APIs}
  s.description = %q{ScrApify scraps static html sites to RESTlike APIs}

  s.rubyforge_project = "scrapify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "fakeweb"
  # s.add_runtime_dependency "nokogiri"
end
