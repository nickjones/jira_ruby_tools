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

        opt :issue_key, "JIRA issue key (i.e. FOO-123 for single ticket)", :type => String
        opt :jql_query, "JIRA JQL query (batch)", :type => String
        opt :new_time, "New time estimate (or remaining time for started tickets) as would be entered into the field (i.e. 2w for two weeks)", :type => String
      end
    end

    def self.execute_command
      Trollop::die :issue_key, "must exist" unless @opts[:issue_key_given] or @opts[:jql_query_given]
      Trollop::die :jql_query, "must exist" unless @opts[:jql_query_given] or @opts[:issue_key_given]
      Trollop::die :new_time, "must exist" unless @opts[:new_time_given]

      self.change_original_estimate
    end

    def self.change_original_estimate
      server = JiraRubyTools.server
      agent = JiraRubyTools::Common.mechanize_agent

      # Make a cheap issue list if we're given a specific one
      if @opts[:jql_query_given]
        issue_list = JiraRubyTools::Common.issue_list_from_jql(@opts[:jql_query])
      else
        issue_list = {"issues" => [{"key" => @opts[:issue_key]}]}
      end

      raise ArgumentError, "JiraRubyTools: JQL returned zero JIRA tickets to work on." if issue_list.nil? or issue_list["issues"].nil? or issue_list["issues"].length == 0

      issue_list["issues"].each do |issue|
        ## Grab the issue by it's common name to get the id
        issue_page = agent.get("#{server}/browse/#{issue['key']}")
        
        # Check if we failed auth
        if issue_page.title.match(/Log in/)
          STDERR.puts "Failed login; are you sure the cookie was correct (and valid)?"
          exit 1
        end
        
        edit_page = agent.click(issue_page.link_with(:text=>/Edit - .*/))
        edit_form = edit_page.form_with(:action=>/EditIssue.jspa/)
        edit_form['timetracking'] = @opts[:new_time]
        edit_form.submit
        puts "JiraRubyTools: Updated timetracking field to #{@opts[:new_time]} for #{issue['key']}"
      end
    end
  end
end
