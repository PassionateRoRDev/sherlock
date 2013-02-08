class SubscriptionPlan < ActiveRecord::Base

  attr_accessor :reports_to_consider_upgrade
  
  def self.all_but_free    
    SubscriptionPlan.where('price > 0 AND chargify_slug IS NOT NULL')    
  end
  
  def plans_to_upgrade
    SubscriptionPlan.where('price > ?', self.price)
  end
  
  def storage_in_gb
    storage_max_mb / 1024
  end

end
