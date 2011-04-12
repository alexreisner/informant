# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "informant"
  s.version     = File.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alex Reisner"]
  s.email       = ["alex@alexreisner.com"]
  s.homepage    = "http://github.com/alexreisner/informant"
  s.date        = Date.today.to_s
  s.summary     = "Form-building library for Rails."
  s.description = "Informant is a full-featured form builder for Ruby on Rails which promotes a simple syntax that keeps your views clean. Everything about a field (label, description, error display, etc) is encapsulated in a single method call."
  s.files       = `git ls-files`.split("\n") - %w[informant.gemspec Gemfile]
  s.require_paths = ["lib"]
end
