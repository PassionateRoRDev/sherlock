class Chargify::SubscriptionsController < ApplicationController
  
  def new  
    logger.debug 'NEW RECEIVED'    
    render :text => 1
  end
  
end
