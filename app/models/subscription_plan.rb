class SubscriptionPlan < ActiveRecord::Base

  def self.all_but_free    
    SubscriptionPlan.where('price > 0 AND chargify_slug IS NOT NULL')    
  end
  
  def plans_to_upgrade
    SubscriptionPlan.where('price > ?', self.price)
  end

end
