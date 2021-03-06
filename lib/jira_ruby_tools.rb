# -*- encoding: utf-8 -*-
require "jira_ruby_tools/version"
require "jira_ruby_tools/common"

module JiraRubyTools
  # Callback hook for functionality registration.  Used by the command line
  # tool.
  def self.included(mod)
    @modules ||= []
    @modules << mod unless @modules.include?(mod)
  end

  def self.modules
    @modules unless @modules.nil?
  end

  def self.sub_commands
    @modules.map do |m|
      m.module_eval('sub_command')
    end
  end

  # Change default JIRA instance URI (i.e. http://jira.mycompany.com)
  def self.server=(server)
    @server=server
  end

  # JIRA instance URI (i.e. http://jira.mycompany.com)
  def self.server
    @server ||= "http://jira"
  end
end

# Must occur after definition for registration to work
dir = File.dirname(__FILE__)
Dir.glob("#{dir}/jira_ruby_tools/modules/*.rb") do |file|
  require file
end

