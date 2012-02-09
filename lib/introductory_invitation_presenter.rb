class IntroductoryInvitationPresenter

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
    'http://' + APP_CONFIG['domain'] + "/users/invitation/accept?invitation_token=#{user.invitation_token}"
  end
end

