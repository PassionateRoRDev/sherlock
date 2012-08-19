class InvitationsController < ApplicationController

  before_filter :authenticate_user!  
  before_filter :authorize_pi!
  before_filter :initialize_case!, :only => [:new, :create ]
  
  def new    
    @invitation = Invitation.new(:case_id => @case.id)        
    @existing_clients = existing_clients
    
  end
  
  def index
    redirect_to clients_path
  end

  def create
    
    @invitation = Invitation.new( params[:invitation] )
    @invitation.current_user = current_user
    
    if @invitation.valid?
    
      @invitation.current_user = current_user

      #"#{cases_url}/#{@invitation.case.id}.pdf"      
      @invitation.url_report = report_url(@invitation.case.id)
      
      @invitation.url_invitation = accept_user_invitation_url
    
      if @invitation.deliver
        flash[:notice] = "Sent invitation to view the report."
        redirect_to @invitation.case
      else       
        @existing_clients = existing_clients
        render 'new'
      end
    else
      @existing_clients = existing_clients
      render 'new'
    end
  end
  
  protected
  
  def existing_clients    
    current_user.clients.map do |c|
      {
        :email      => c.email,
        :first_name => c.first_name,
        :last_name  => c.last_name
      }
    end
  end
  
  def initialize_case!
    
    @case = current_user.authored_cases.find_by_id(params[:case_id])
    return redirect_to cases_path unless @case    
    
  end

end

