class RepeatInvitationPresenter

  def initialize( invitation )
    @invitation = invitation
  end

  def user
    @invitation.user
  end

  def recipient
    "#{@invitation.name} <#{@invitation.email}>"
  end

  def message
    @invitation.message
  end

  def help_message
    "You may need to sign in if you have not done so recently. Then you will be taken directly to your report."
  end

  def link_text
    "View Report"
  end

  def link_target
    'http://' + APP_CONFIG['domain'] + "/cases/#{@invitation.case.id}.pdf"
  end
end

