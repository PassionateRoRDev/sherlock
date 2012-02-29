class HomeController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:dashboard]
  
  def index    
    @title = 'SherlockDocs'
    render 'index', :layout => 'public'
  end
  
  def tour
    render 'tour', :layout => 'public'
  end
  
  def help
    render 'help', :layout => 'public'
  end
  
  def customers
    render 'customers', :layout => 'public'
  end
  
  def dashboard
    @cases = current_user.cases
  end
  
  def pricing
    @title = 'Plans and Pricing'
    render 'pricing', :layout => 'public'
    
  end
  
end
