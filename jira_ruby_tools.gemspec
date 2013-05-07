# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jira_ruby_tools/version'

Gem::Specification.new do |gem|
  gem.name          = "jira_ruby_tools"
  gem.version       = JiraRubyTools::VERSION
  gem.authors       = ["Nick Jones"]
  gem.email         = ["darellik@gmail.com"]
  gem.description   = %q{Ruby tools to modify JIRA tickets for JIRA 4.x.}
  gem.summary       = %q{A library of classes to modify JIRA 4.x. tickets in ways not possible with the typical REST or SOAP interfaces.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_runtime_dependency "mechanize"
  gem.add_runtime_dependency "trollop"
  gem.add_runtime_dependency "highline"
  gem.add_runtime_dependency "httparty"
end
