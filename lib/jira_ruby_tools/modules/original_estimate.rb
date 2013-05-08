# -*- encoding: utf-8 -*-

require 'trollop'
require 'jira_ruby_tools/common'

# To-Do:
# * Add JQL based bulk change support

module JiraRubyTools
  module OriginalEstimate
    include JiraRubyTools # Registration

    def self.sub_command
      'orig_est'
    end
  
    def self.command_line_options
      @opts = Trollop::options do
        banner "Scripted changing of the Original/Remaining Estimate field for a ticket in liu of a real API from Atlassian."

        opt :issue_key, "JIRA issue key (i.e. FOO-123)", :type => String, :required => true
        opt :new_time, "New time estimate (or remaining time for started tickets) as would be entered into the field (i.e. 2w for two weeks)", :type => String, :required => true
      end
    end

    def self.execute_command
      Trollop::die :issue_key, "must exist" unless @opts[:issue_key_given]
      Trollop::die :new_time, "must exist" unless @opts[:new_time_given]

      self.change_original_estimate
    end

    def self.change_original_estimate
      server = JiraRubyTools.server
      agent = JiraRubyTools::Common.mechanize_agent

      ## Grab the issue by it's common name to get the id
      issue_page = agent.get("#{server}/browse/#{@opts[:issue_key]}")
      
      # Check if we failed auth
      if issue_page.title.match(/Log in/)
        STDERR.puts "Failed login; are you sure the cookie was correct (and valid)?"
        exit 1
      end
      
      edit_page = agent.click(issue_page.link_with(:text=>/Edit - .*/))
      edit_form = edit_page.form_with(:action=>/EditIssue.jspa/)
      edit_form['timetracking'] = @opts[:new_time]
      edit_form.submit
      puts "JiraRubyTools: Updated timetracking field to #{@opts[:new_time]} for #{@opts[:issue_key]}"
    end
  end
end
