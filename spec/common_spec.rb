require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

def stub_mechanize_instance
  agent = Mechanize.new
  Mechanize.stub(:new).and_return(agent)
  JiraRubyTools::Common.stub(:mechanize_agent).and_return(agent)
  JiraRubyTools::Common.stub(:server).and_return("http://localhost")
end

describe JiraRubyTools::Common do

  specify "#mechanize_agent creates a new Mechanize instance if one has not been created" do
    agent = Mechanize.new
    Mechanize.stub(:new).and_return(agent)
    JiraRubyTools::Common.mechanize_agent.should eq(agent)
    JiraRubyTools::Common.mechanize_agent.should eq(agent)
  end

  specify "#cookie provides a session cookie for additional accesses without auth" do
    JiraRubyTools::Common.cookie
  end

  specify "#login_with_password requires an argument" do
    lambda { JiraRubyTools::Common.login_with_password.should raise_error(ArgumentError) }
  end

  specify "#login_wth_password should mechanize the login form" do
    pending do
      stub_mechanize_instance
      JiraRubyTools::Common.login_with_password("testuser")
    end
  end

end
