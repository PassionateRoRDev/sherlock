class EventsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  def create
    
  end
  
end
