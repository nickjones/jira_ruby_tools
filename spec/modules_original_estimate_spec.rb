require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe JiraRubyTools::OriginalEstimate do
  specify "#sub_command should be 'orig_est'" do
    JiraRubyTools::OriginalEstimate.sub_command.should == 'orig_est'
  end

  ['issue-key', 'jql-query', 'new-time'].each do |opt|
    specify "#command_line_options should support a '#{opt}' option and take a string" do
      orig_args = ARGV
      ARGV.clear
      ARGV.unshift "--#{opt}=\"a string\""
      expect { JiraRubyTools::OriginalEstimate.command_line_options}.not_to raise_error(SystemExit)
    end
  end

  ['issue-key', 'jql-query', 'new-time'].each do |opt|
    specify "#command_line_options should require the '#{opt}' option to have a parameter" do
      orig_args = ARGV
      ARGV.clear
      ARGV.unshift "--#{opt}"
      expect { JiraRubyTools::OriginalEstimate.command_line_options}.to raise_error(SystemExit)
    end
  end
end
