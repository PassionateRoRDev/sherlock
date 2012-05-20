class SampleReportPresenter
  
  attr_accessor :email
  attr_accessor :link_signup
  
  def initialize(email, link_signup)
    @email        = email
    @link_signup  = link_signup    
  end
  
end