$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "creation_report/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "creation_report"
  s.version     = CreationReport::VERSION
  s.authors     = ["Jon Collier"]
  s.email       = ["gem@joncollier.com"]
  s.homepage    = ""
  s.summary     = "Easily generate graphs for ActiveRecord object creation."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "gchartrb"
  s.add_dependency "mysql"

  s.add_development_dependency "sqlite3"
end
