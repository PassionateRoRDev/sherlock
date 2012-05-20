require 'spec_helper'

describe SampleReport do
  
  it "should send email" do
  
    s = SampleReport.new
    s.link_signup = 'http://sherlockdocs.com/signup'
    s.email = 'user@user.com'
    s.deliver
  end
  
end
        