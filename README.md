# JiraRubyTools

[![Build Status](https://travis-ci.org/nickjones/jira_ruby_tools.png?branch=master)](https://travis-ci.org/nickjones/jira_ruby_tools)
[![Dependency Status](https://gemnasium.com/nickjones/jira_ruby_tools.png)](https://gemnasium.com/nickjones/jira_ruby_tools)

Assortment of helper methods to manage tickets in bulk on JIRA 4.4 where either an API or the web interface to make these operations doesn't exist.
## Installation
Install the gem normally:

    gem install jira_ruby_tools

Use the new `update_jira` console command to make bulk changes.

### Inclusion in Other Tools
Add this line to your application's Gemfile:

    gem 'jira_ruby_tools'

And then execute:

    $ bundle

## Usage

See `update_jira --help` for command line instructions.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
