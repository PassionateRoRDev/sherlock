class AddChargifySlugAndPriceToSubscriptionPlans < ActiveRecord::Migration
  def change
    add_column :subscription_plans, :chargify_slug, :string
    add_column :subscription_plans, :price, :decimal
    
    SubscriptionPlan.reset_column_information            
    mapping = {
      :independent  => { :slug => 'h/285859', :price => 9  },
      :agency       => { :slug => 'h/286025', :price => 29  },
      :corporate    => { :slug => 'h/286061', :price => 99  }
    }    
    mapping.each do |handle, fields|
      s = SubscriptionPlan.find_by_chargify_handle(handle)
      s.chargify_slug   = fields[:slug]
      s.price           = fields[:price]
      s.save!
    end
    
    
  end
    
  
end
