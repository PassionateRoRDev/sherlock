class HomeController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:dashboard]
  before_filter :check_public_section, :except => [:dashboard]
  
  def index    
    @title = 'SherlockDocs'
    #render :layout => 'public'
    
    @email = CapturedEmail.new
    
    render 'landing', :layout => false
  end
  
  def contact
    redirect_to new_contact_message_path
  end
  
  def tos
    @title = "Terms of Service"
    #render :layout => 'public'
    render :layout => false
  end
  
  def privacy
    @title = "Privacy Policy"
    #render :layout => 'public'
    render :layout => false
  end
  
  def tour
    @title = 'Tour'
    render :layout => 'public'
  end
  
  def help
    @title = 'Help & Support'
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
    
    url_base = 'https://sherlockdocs.chargify.com/'
    
    @plan1 = SubscriptionPlan.find_by_chargify_handle(:independent)
    @plan2 = SubscriptionPlan.find_by_chargify_handle(:agency)
    @plan3 = SubscriptionPlan.find_by_chargify_handle(:corporate)
    @plan4 = SubscriptionPlan.find_by_chargify_handle(:company)
    
    @url_plan1 = url_base + @plan1.chargify_slug + '/subscriptions/new'
    @url_plan2 = url_base + @plan2.chargify_slug + '/subscriptions/new'
    @url_plan3 = url_base + @plan3.chargify_slug + '/subscriptions/new'
    @url_plan4 = url_base + @plan4.chargify_slug + '/subscriptions/new'
    
    @url_plan1 = subscription_plan_path(:independent)
    @url_plan2 = subscription_plan_path(:agency)
    @url_plan3 = subscription_plan_path(:corporate)
    @url_plan4 = subscription_plan_path(:company)
    
    render 'pricing', :layout => 'public'
  end

  private

  #
  # Disable public pages for now for the production environment
  #
  def check_public_section
    #redirect_to dashboard_path if (Rails.env == 'production' && action_name == 'index')
  end
  
end
