# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'informant/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = "informant"
  spec.version       = Informant::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Alex Reisner", "Janusz Mordarski"]
  spec.email         = ["alex@alexreisner.com", "janusz.m@gmail.com"]
  spec.homepage      = "http://github.com/alexreisner/informant"
  spec.date          = Date.today.to_s

  spec.summary       = "Form-building library for Rails."
  spec.description   = "Informant is a full-featured form builder for Ruby on Rails which promotes a simple syntax that keeps your views clean. Everything about a field (label, description, error display, etc) is encapsulated in a single method call."

  spec.files         = `git ls-files`.split("\n") - %w[informant.gemspec Gemfile]
  spec.require_paths = ["lib"]

  spec.add_dependency('actionview')
  spec.add_development_dependency('actionpack')
  spec.add_development_dependency('minitest-reporters')
end
