class ClientsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index    
    @clients = current_user.clients    
  end
end
