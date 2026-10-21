# frozen_string_literal: true

require_relative "lib/jekyll-ical-feed/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-ical-feed"
  spec.version = JekyllIcalFeed::VERSION
  spec.authors = ["Joshua Töpfer"]
  spec.summary = "Subscribable iCalendar (.ics) feeds for Jekyll, generated from data files or collections."
  spec.homepage = "https://github.com/hollesse/jekyll-ical-feed"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 4.0", "< 5.0"
end
