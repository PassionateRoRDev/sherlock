class InvitationsController < ApplicationController

  before_filter :authenticate_user!  
  before_filter :authorize_pi!  
  
  def new    
    @invitation = Invitation.new(:case_id => params[:case_id])            
  end

  def create
    
    @invitation = Invitation.new( params[:invitation] )
    @invitation.current_user = current_user
    
    if @invitation.deliver
      flash[:notice] = "Sent invitation to view the report."
      redirect_to @invitation.case
    else
      render :action => 'new'
    end
  end

end

