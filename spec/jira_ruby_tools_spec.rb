require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe JiraRubyTools do
  specify "default server of 'http://jira/'" do
    JiraRubyTools.server.should == "http://jira/"
  end

  specify "allows changing the default server" do
    test_server = "http://my.jirainstance.foo.bar:8080"
    orig_server = JiraRubyTools.server
    JiraRubyTools.server=test_server
    JiraRubyTools.server.should == test_server
    JiraRubyTools.server=orig_server # Clean up for other tests
  end

  specify "add keep track of modules that include JiraRubyTools to reflect on for functionality" do
    module JiraRubyTools::SpecTestModule
      include JiraRubyTools
    end
    JiraRubyTools.modules.should include(JiraRubyTools::SpecTestModule)
  end

  specify "registered modules should only appear once" do
    3.times { module JiraRubyTools::SpecTestModuleReplicationTest; include JiraRubyTools; end }

    JiraRubyTools.modules.should == JiraRubyTools.modules.uniq
  end

  specify "#sub_commands iterates through registered modules calling the #sub_commands method"

end
