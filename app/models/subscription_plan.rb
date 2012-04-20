class SubscriptionPlan < ActiveRecord::Base


    def plans_to_upgrade
      SubscriptionPlan.where('price > ?', self.price)
    end

end
