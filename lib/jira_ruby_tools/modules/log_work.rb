# -*- encoding: utf-8 -*-

require 'trollop'
require 'jira_ruby_tools/common'

module JiraRubyTools
  module LogWork
    include JiraRubyTools # Registration

    def self.sub_command
      'log_work'
    end

    def self.command_line_options
      @opts = Trollop::options do
        banner "Scripted changing of the Original/Remaining Estimate field for a ticket in liu of a real API from Atlassian."
        opt :jql_query, "JQL", :type => String
        opt :time, "Time worked as would be entered into the field (i.e. 2w for two weeks)", :type => String
        opt :comment, "(Optional) Comment to be included in the work log.", :type => String
      end
    end

    def self.execute_command
      Trollop::die :jql_query, "must exist" unless @opts[:jql_query_given]
      Trollop::die :time, "must exist" unless @opts[:time_given]

      self.log_work
    end

    def self.log_work
      agent = JiraRubyTools::Common.mechanize_agent

      issue_list = JiraRubyTools::Common.issue_list_from_jql(@opts[:jql_query])

      raise ArgumentError, "JiraRubyTools: JQL returned zero JIRA tickets to work on." if issue_list["issues"].length == 0 or issue_list.nil?

      issue_list["issues"].each do |issue|
        issue_page = agent.get("#{JiraRubyTools.server}/browse/#{issue['key']}")
        work_log_action = agent.click(issue_page.link_with(:text=>"Log Work"))
        log_work_form = work_log_action.form_with(:action=>/CreateWorklog.jspa/)
        log_work_form['timeLogged'] = @opts[:time]
        log_work_form['comment'] = @opts[:comment] if @opts[:comment_given]
        log_work_form.submit
        puts "JiraRubyTools: Logged #{@opts[:time]} on #{issue['key']}"
      end
    end
  end
end
