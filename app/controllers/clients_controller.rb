class ClientsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :resolve_client, :only => [:show, :edit, :update ]
  
  def index    
    @clients = current_user.clients    
  end
  
  def show            
  end
  
  def edit
    
  end
  
  def update    
    p = params[:user]
    @client.first_name = p[:first_name]
    @client.last_name = p[:last_name]
    
    if @client.save      
      redirect_to client_path(@client), :notice => 'Client info has been updated'
    else
      flash[:alert] = 'Client info could not be updated'
      render 'edit'
    end
  end
  
  private
  
  def resolve_client
    @client = current_user.clients.find_by_id(params[:id])
    redirect_to clients_path unless @client
  end
  
end
