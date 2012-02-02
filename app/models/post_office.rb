class PostOffice < ActionMailer::Base

  def report( invitation )
    @invitation = invitation
    mail(
      :to => @invitation.target, 
      :subject => 'View Report', 
      :from => APP_CONFIG[:sender]
    )
  end

end

