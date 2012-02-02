class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new(:case_id => params[:case_id])
  end

  def create
    @invitation = Invitation.new( params[:invitation] )
    if @invitation.deliver
      flash[:notice] = "Sent invitation to view the report."
      redirect_to @invitation.case
    else
      render :action => 'new'
    end
  end

end

