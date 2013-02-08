class HomeController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:dashboard]
  before_filter :check_public_section, :except => [:dashboard]
  
  layout "public"
  
  def index    
    @title = 'SherlockDocs'
    #render :layout => 'public'
    @active_navlink = "home"
    @email = CapturedEmail.new
    
    render 'landing'
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
  
  def how_it_works
    @active_navlink = "how_it_works"
  end
  
  def dashboard
    #@cases = current_user.cases
    redirect_to cases_path
  end
  
  def pricing
    @title = 'Plans and Pricing'
    @active_navlink = "pricing"
    
    @plan_independent   = SubscriptionPlan.find_by_chargify_handle(:independent)
    @plan_agency        = SubscriptionPlan.find_by_chargify_handle(:agency)
    @plan_corporate     = SubscriptionPlan.find_by_chargify_handle(:corporate)
    @plan_company       = SubscriptionPlan.find_by_chargify_handle(:company)
    @plan_pay_as_you_go = SubscriptionPlan.find_by_chargify_handle(:payasyougo)
    
    @plan_independent.reports_to_consider_upgrade   = 9
    @plan_agency.reports_to_consider_upgrade        = 21
    @plan_company.reports_to_consider_upgrade       = 43
    @plan_corporate.reports_to_consider_upgrade     = 0
    @plan_pay_as_you_go.reports_to_consider_upgrade = 0
        
    @url_independent     = subscription_plan_path(:independent)
    @url_agency          = subscription_plan_path(:agency)
    @url_corporate       = subscription_plan_path(:corporate)
    @url_company         = subscription_plan_path(:company)
    @url_pay_as_you_go   = subscription_plan_path(:payasyougo)
    
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
