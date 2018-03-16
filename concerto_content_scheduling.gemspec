$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "concerto_content_scheduling/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "concerto_content_scheduling"
  s.version     = ConcertoContentScheduling::VERSION
  s.authors     = ["Concerto Developers"]
  s.email       = ["perez283@gmail.com"]
  s.homepage    = "http://concerto-signage.org"
  s.summary     = "Schedule content for different times of day."
  s.description = "Add more content scheduling options."
  s.license     = "Apache-2.0"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency "rails", "~> 4.2.6"
  s.add_runtime_dependency "ice_cube", "~> 0.16.2"
  s.add_runtime_dependency "recurring_select", '~> 1.2.1'

  # s.add_development_dependency "sqlite3"

end
