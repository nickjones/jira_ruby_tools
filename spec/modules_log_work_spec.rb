require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe JiraRubyTools::LogWork do
  specify "#sub_command should be 'log_work'" do
    JiraRubyTools::LogWork.sub_command.should == 'log_work'
  end

  ['jql-query', 'time', 'comment'].each do |opt|
    specify "#command_line_options should support a '#{opt}' option and take a string" do
      orig_args = ARGV
      ARGV.clear
      ARGV.unshift "--#{opt}=\"a string\""
      expect { JiraRubyTools::LogWork.command_line_options}.not_to raise_error(SystemExit)
    end
  end

  ['jql-query', 'time', 'comment'].each do |opt|
    specify "#command_line_options should require the '#{opt}' option to have a parameter" do
      orig_args = ARGV
      ARGV.clear
      ARGV.unshift "--#{opt}"
      expect { JiraRubyTools::LogWork.command_line_options}.to raise_error(SystemExit)
    end
  end

  specify "#jql_query= exists" do
    JiraRubyTools::LogWork.jql_query="project=foo AND priority=High"
  end

  specify "#time= exists" do
    JiraRubyTools::LogWork.time="2h"
  end
  
  specify "#comment= exists" do
    JiraRubyTools::LogWork.comment="This is a test comment."
  end

end
