# -*- encoding: utf-8 -*-
require 'mechanize'
require 'uri'
require 'httparty'
require 'highline/import'

module JiraRubyTools
  module Common
    def self.mechanize_agent
      @mechanize_agent ||= Mechanize.new
    end

    def self.cookie
      @cookie
    end

    def self.login_with_password(login)
      login_page = self.mechanize_agent.get("#{JiraRubyTools.server}/login.jsp")
      login_form = login_page.form_with(:action=>/login\.jsp/)
      login_form["os_username"] = login
      login_form["os_password"] = password = ask("Password: ") {|q| q.echo = false }
      login_form.checkbox_with(:name=>"os_cookie").check
      login_form.submit
      # Grab all of the cookies we got from JIRA
      cookies = self.mechanize_agent.cookie_jar.cookies(URI.parse(JiraRubyTools.server))
      # Filter down to just the remember me one for future use.
      cookies.keep_if{|c| c.name.match(/rememberme/)}
      puts "JiraRubyTools: Cookie for next time: #{cookies.first.value}"

      @cookie = cookies.first.to_s
    end

    def self.login_with_cookie(cookie)
      cookie = Mechanize::Cookie.new('seraph.rememberme.cookie', cookie)
      cookie.domain = URI.parse(JiraRubyTools.server).host
      cookie.path = "/"
      self.mechanize_agent.cookie_jar.add! cookie

      @cookie = self.mechanize_agent.cookies.first.to_s
    end

    def self.issue_list_from_jql(jql)
      issue_list = HTTParty.get("#{JiraRubyTools.server}/rest/api/2.0.alpha1/search?jql=#{URI.encode(jql)}",
                          :headers => {'Cookie' => self.cookie})

      if issue_list["issues"].length == 0
        return nil
      else
        return issue_list
      end
    end

  end
end
