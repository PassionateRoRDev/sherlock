class InvitationsController < ApplicationController

  before_filter :authenticate_user!  
  before_filter :authorize_pi!  
  
  def new    
    @invitation = Invitation.new(:case_id => params[:case_id])    
  end

  def create
    
    @invitation = Invitation.new( params[:invitation] )
    @invitation.current_user = current_user
    
    @invitation.url_cases = cases_url
    @invitation.url_invitation = accept_user_invitation_url
    
    if @invitation.deliver
      flash[:notice] = "Sent invitation to view the report."
      redirect_to @invitation.case
    else
      render :action => 'new'
    end
  end

end

