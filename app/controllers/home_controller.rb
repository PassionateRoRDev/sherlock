class HomeController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:pricing]
  
  def index    
    @cases = current_user.cases    
  end
  
  def pricing
    
    render 'pricing', :layout => false
    
  end
  
end
