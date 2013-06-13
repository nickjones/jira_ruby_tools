# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jira_ruby_tools/version'

Gem::Specification.new do |gem|
  gem.name                 = "jira_ruby_tools"
  gem.version              = JiraRubyTools::VERSION
  gem.authors              = ["Nick Jones"]
  gem.email                = ["darellik@gmail.com"]
  gem.description          = %q{Ruby tools to modify JIRA tickets for JIRA 4.x.}
  gem.summary              = %q{A library of classes to modify JIRA 4.x. tickets in ways not possible with the typical REST or SOAP interfaces.}
  gem.homepage             = "http://github.com/nickjones/jira_ruby_tools"

  gem.files                = `git ls-files`.split($/)
  gem.executables          = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files           = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths        = ["lib"]
  gem.license              = "MIT"
  gem.post_install_message = "Use 'update_jira' for the CLI tool."
  gem.requirements        << "JIRA 4.x"

  gem.add_development_dependency "rake", "~>0.9.2"
  gem.add_development_dependency "rspec", "~>2.13.0"
  gem.add_development_dependency "pry"

  gem.add_runtime_dependency "nokogiri", "~>1.6.0"
  gem.add_runtime_dependency "mechanize", "~>2.7.0"
  gem.add_runtime_dependency "trollop", "~>2.0"
  gem.add_runtime_dependency "highline", "~>1.6.18"
  gem.add_runtime_dependency "httparty", "~>0.11.0"
  gem.add_runtime_dependency "json_pure", ">=1.7.7"
end
