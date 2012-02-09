class PostOffice < ActionMailer::Base

  def invitation( invitation )
    @invitation = invitation
    mail(
      :to => @invitation.recipient, 
      :subject => 'View Report', 
      :from => APP_CONFIG[:sender]
    )
  end

end

