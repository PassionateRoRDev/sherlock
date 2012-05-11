class SubscriptionPlansController < ApplicationController
  
  def show
    
    plan = SubscriptionPlan.find_by_chargify_handle params[:id]    
    return redirect_to root_path unless plan
    
    KM.record 'Selected Plan', :plan_type => params[:id]
    
    url_base = 'https://sherlockdocs.chargify.com/'
    url_plan = url_base + plan.chargify_slug + '/subscriptions/new'
    redirect_to url_plan        
    
  end  
  
end
