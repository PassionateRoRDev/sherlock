module PlanHelper
  
  CHARGIFY_BASE = 'https://sherlockdocs.chargify.com/'
  
  def chargify_url(plan)            
    CHARGIFY_BASE +  plan.chargify_slug + '/subscriptions/new'    
  end
  
end