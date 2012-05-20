class SampleReport
  
  attr_accessor :link_signup
  attr_accessor :email
  
  def deliver
    
    presenter = SampleReportPresenter.new(email, link_signup)
    PostOffice.sample_report(presenter).deliver    
    
  end
  
end
