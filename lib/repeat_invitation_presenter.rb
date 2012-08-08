class RepeatInvitationPresenter

  attr_accessor :url_report
  
  def initialize(invitation, url)
    @invitation = invitation
    @url_report = url
  end

  def user
    @invitation.user
  end

  def recipient
    "#{@invitation.name} <#{@invitation.email}>"
  end

  def invitation
    @invitation
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
    #"#{url_cases}/#{@invitation.case.id}.pdf"
    url_report    
  end
end

