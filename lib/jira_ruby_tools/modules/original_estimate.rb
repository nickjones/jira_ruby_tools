#!/usr/bin/env ruby

require 'trollop'
require 'mechanize'

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

    def self.change_original_estimate
      @agent = ::Mechanize.new
      
      if @opts[:login_given] && !@opts[:cookie_given]
        login_page = @agent.get("#{@opts[:server]}/login.jsp")
        login_form = login_page.form_with(:action=>/login\.jsp/)
        login_form["os_username"] = @opts[:login]
        login_form["os_password"] = password = ask("Password: ") {|q| q.echo = false }
        login_form.checkbox_with(:name=>"os_cookie").check
        login_form.submit
        # Grab all of the cookies we got from JIRA
        cookies = @agent.cookie_jar.cookies(URI.parse(@opts[:server]))
        # Filter down to just the remember me one for future use.
        cookies.keep_if{|c| c.name.match(/rememberme/)}
        puts "Cookie for next time:"
        puts cookies.first.value
      else
        cookie = Mechanize::Cookie.new('seraph.rememberme.cookie', @opts[:cookie])
        cookie.domain = URI.parse(@opts[:server]).host
        cookie.path = "/"
        @agent.cookie_jar.add! cookie
      end
      
      ## Grab the issue by it's common name to get the id
      issue_page = @agent.get("#{@opts[:server]}/browse/#{@opts[:issue_key]}")
      
      # Check if we failed auth
      if issue_page.title.match(/Log in/)
        STDERR.puts "Failed login; are you sure the cookie was correct (and valid)?"
        exit 1
      end
      
      edit_page = @agent.click(issue_page.link_with(:text=>/Edit - .*/))
      edit_form = edit_page.form_with(:action=>/EditIssue.jspa/)
      edit_form['timetracking'] = @opts[:new_time]
      edit_form.submit
      puts "Updated timetracking field to #{@opts[:new_time]} for #{@opts[:issue_key]}"
    end
  end
end
