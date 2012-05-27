class Subscription < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :subscription_plan
  
  default_scope :order => 'period_ends_at'
  
  INACTIVE_STATES = %w{past_due unpaid canceled expired suspended}
  
  #
  # Create Subscription record from the ChargifySubscription received from
  # Chargify API
  #
  def self.create_from_chargify(subscription)
    
    plan = SubscriptionPlan.find_by_chargify_handle(subscription.product.handle)
          
    find_or_create_by_chargify_id(
      :chargify_id        => subscription.id,
      :product_handle     => plan.chargify_handle,
      :subscription_plan  => plan,
      :period_ends_at     => subscription.current_period_ends_at,
      :next_assessment_at => subscription.next_assessment_at,
      :status             => subscription.state,

      :cases_max          => plan.cases_max,
      :cases_count        => 0,
      :clients_max        => plan.clients_max,
      :clients_count      => 0,
      :storage_max_mb     => plan.storage_max_mb,

      :extra_case_price   => plan.extra_case_price,
      :extra_cases_count  => 0
    )
    
  end
  
  def apply_chargify_event(subscription_payload)
    
    if self.period_ends_at != subscription_payload[:current_period_ends_at]
      self.extend(subscription_payload[:current_period_ends_at], subscription_payload[:state])
    else
      self.status = subscription_payload[:state]
      save
    end
                
  end
  
  def extend(period_end, status)
    
    plan = self.subscription_plan
    Subscription.create(
      :chargify_id        => self.chargify_id,
      :product_handle     => plan.chargify_handle,
      :user               => self.user,
      :subscription_plan  => plan,
        
      :period_ends_at     => period_end,
      :next_assessment_at => self.next_assessment_at,
      
      :status             => status,
      
      :cases_max          => plan.cases_max, 
      :cases_count        => 0,
      
      :extra_case_price   => plan.extra_case_price, 
      :extra_cases_count  => 0,
      
      :clients_max        => plan.clients_max, 
      :clients_count      => 0,
      
      :storage_max_mb     => plan.storage_max_mb
    )
    
  end
  
  def is_inactive?
    INACTIVE_STATES.include? self.status
  end
  
  def is_active?    
    !is_inactive?
  end
  
  def plans_to_upgrade
    self.subscription_plan.plans_to_upgrade
  end
    
  def extra_case_created(c)
    self.extra_cases_count += 1
    save!
  end
  
  def case_created(c)
    self.cases_count += 1
    save!
  end
    
end
