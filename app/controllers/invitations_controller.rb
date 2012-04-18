class InvitationsController < ApplicationController

  before_filter :authenticate_user!  
  before_filter :authorize_pi!  
  
  def new
    @case = current_user.authored_cases.find_by_id(params[:case_id])
    return redirect_to cases_path unless @case
    
    @invitation = Invitation.new(:case_id => @case.id)    
  end
  
  def index
    redirect_to clients_path
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

