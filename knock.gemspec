$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "knock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doorbell"
  s.version     = Knock::VERSION
  s.authors     = ["MinuteMedia"]
  s.email       = ["tech@minutemedia.com"]
  s.homepage    = "https://github.com/nsarno/knock"
  s.summary     = "Simple JWT authentication for Rails API."
  s.description = "Authentication solution for Rails based on JWT"
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "jwt", "~> 1.5"
  s.add_dependency "bcrypt", "~> 3.1"

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "timecop", "~> 0.8.0"
end
