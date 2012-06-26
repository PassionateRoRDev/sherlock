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
  
  def sample_report(presenter)
    
    email         = presenter.email
    @link_signup  = presenter.link_signup
    
    filename = 'Jone-Spouse-Cheating.pdf'
    filepath = File.join(Rails.root, 'script', filename)
    attachments[filename] = File.read(filepath);
    
    mail(
      :to => email,
      :subject => 'Your Sample Report from SherlockDocs', 
      :from => APP_CONFIG['sender'],
      :return_path => APP_CONFIG['sender']
    )
    
  end
  
  def free_trial_1_week(presenter)
    
    @user = presenter.user
    email = @user.email
    
    mail(
      :to => email,
      :subject => 'Your free trial of SherlockDocs - 1 week left', 
      :from => APP_CONFIG['sender'],
      :return_path => APP_CONFIG['sender']
    )
    
  end
  
  def free_trial_4_days(presenter)
    @user = presenter.user
    email = @user.email
    
    mail(
      :to => email,
      :subject => 'Your free trial of SherlockDocs - 4 days left', 
      :from => APP_CONFIG['sender'],
      :return_path => APP_CONFIG['sender']
    )
    
  end
  
  def free_trial_expiration(presenter)    
    @user = presenter.user
    email = @user.email
    
    mail(
      :to => email,
      :subject => 'Your free trial of SherlockDocs - expiring today!', 
      :from => APP_CONFIG['sender'],
      :return_path => APP_CONFIG['sender']
    )
    
  end
  
  def welcome(presenter)
    
    @recipient = presenter.user    
    @url_main = dashboard_url
    
    mail(
      :to => @recipient.email,
      :subject => 'Welcome to SherlockDocs', 
      :from => APP_CONFIG['sender'],
      :return_path => APP_CONFIG['sender']
    )
  end

end

