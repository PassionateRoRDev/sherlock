class PostOffice < ActionMailer::Base

  def invitation( invitation )

    @invitation = invitation
    mail(
      :to => @invitation.recipient, 
      :subject => 'Link to View the Report', 
      :from => APP_CONFIG['sender'],
      :return_path => APP_CONFIG['sender']
    )
  end

end

