$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "wizardry/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "govuk-wizardry"
  spec.version     = Wizardry::VERSION
  spec.authors     = ["Peter Yates"]
  spec.email       = ["peter.yates@graphia.co.uk"]
  spec.homepage    = "https://www.github.com/graphia/wizardry"
  spec.summary     = "GOV.UK design system wizard generator"
  spec.description = "A gem that allows an entire GOV.UK wizard/journey to be easily defined and built"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "govuk-components", "~> 3.0.1"
  spec.add_dependency "govuk_design_system_formbuilder", "~> 3.0.1"
  spec.add_dependency "rails", ">= 7.0.0"

  spec.add_development_dependency "capybara"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rails-controller-testing"
  spec.add_development_dependency "rspec-expectations"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop-govuk"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "webrick"
end
