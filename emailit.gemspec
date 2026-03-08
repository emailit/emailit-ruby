# frozen_string_literal: true

require_relative "lib/emailit/version"

Gem::Specification.new do |spec|
  spec.name = "emailit"
  spec.version = Emailit::VERSION
  spec.authors = ["Emailit"]
  spec.email = ["support@emailit.com"]

  spec.summary = "Ruby and Rails SDK for the Emailit Email API"
  spec.description = "Official Ruby and Rails SDK for the Emailit Email API. Send emails, manage domains, contacts, templates, and more."
  spec.homepage = "https://emailit.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/emailit/emailit-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/emailit/emailit-ruby/releases"

  spec.files = Dir["lib/**/*.rb", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "mail", "~> 2.7"
end
