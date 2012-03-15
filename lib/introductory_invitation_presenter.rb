class IntroductoryInvitationPresenter

  include Rails.application.routes.url_helpers
  
  def initialize( invitation )
    @invitation = invitation
  end

  def user
    @invitation.guest
  end

  def recipient
    "#{@invitation.name} <#{@invitation.email}>"
  end

  def message
    @invitation.message
  end

  def help_message
    "Since this is your first time using our system, you will need to create a password before you can view your report."
  end

  def link_text
    "Create Password and View Report"
  end

  def link_target    
    host = ActionMailer::Base.default_url_options[:host]
    accept_user_invitation_url(:token => user.invitation_token, :host => host)    
  end
end

