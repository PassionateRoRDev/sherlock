class HomeController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:dashboard]
  before_filter :check_public_section, :except => [:dashboard]
  
  def index    
    @title = 'SherlockDocs'
    render :layout => 'public'
  end
  
  def tour
    @title = 'Tour'
    render :layout => 'public'
  end
  
  def help
    @title = 'Help & Support'
    render :layout => 'public'
  end
  
  def contact
    @title = 'Contact'
    render :layout => 'public'
  end
  
  def customers
    render 'customers', :layout => 'public'
  end
  
  def dashboard
    #@cases = current_user.cases
    redirect_to cases_path
  end
  
  def pricing
    @title = 'Plans and Pricing'
    render 'pricing', :layout => 'public'
  end

  private

  #
  # Disable public pages for now for the production environment
  #
  def check_public_section
    redirect_to dashboard_path if (Rails.env == 'production' && action_name == 'index')
  end
  
end
