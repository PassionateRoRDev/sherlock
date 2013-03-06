class Subscription < ActiveRecord::Base
  include InfusionsoftUtils
  
  belongs_to :user
  belongs_to :subscription_plan
  
  has_many :sent_emails
  
  default_scope :order => 'period_ends_at'
  
  INACTIVE_STATES = %w{past_due unpaid canceled expired suspended}
  
  STATUS_TRIALING = "trialing"
  
  # Create Subscription record from the ChargifySubscription received from
  # Chargify API
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
    
    push_status_change_to_infusionsoft
    
  end
  
  def self.free_trials
    where(:product_handle => :free_trial)
  end
  
  def self.expiring_on(day)
    where('period_ends_at BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day)
  end
  
  def self.create_free_trial
    plan = SubscriptionPlan.find_by_chargify_handle(:free_trial)
    if plan
      Subscription.create(        
        :product_handle     => plan.chargify_handle,
        :subscription_plan  => plan,
        
        :period_ends_at     => Setting.trial_days.days.from_now,
        
        :status             => STATUS_TRIALING,

        :cases_max          => plan.cases_max,
        :cases_count        => 0,
        :clients_max        => plan.clients_max,
        :clients_count      => 0,
        :storage_max_mb     => plan.storage_max_mb,

        :extra_case_price   => plan.extra_case_price,
        :extra_cases_count  => 0
      )
      
      push_status_change_to_infusionsoft
      
    end
  end
  
  def apply_chargify_event(subscription_payload)
    
    if self.period_ends_at != subscription_payload[:current_period_ends_at]      
      self.extend(subscription_payload[:current_period_ends_at], subscription_payload[:state])
    else
      self.status = subscription_payload[:state]
      save
      
      Event.create(
        :event_type     => :subscription,
        :event_subtype  => self.status,
        :detail_i1      => self.id   
      )
      
      push_status_change_to_infusionsoft
      
    end
                
  end
  
  def extend(period_end, status)
    
    plan = self.subscription_plan
    s = Subscription.create(
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
    
    subtype = (status.to_s == 'active') ? :renewal : status
    
    Event.create(
        :event_type     => :subscription,
        :event_subtype  => subtype,
        :detail_s1      => s.period_ends_at.to_s,
        :detail_i1      => s.id        
    )
    
    push_status_change_to_infusionsoft
        
  end    
  
  def is_inactive?
    INACTIVE_STATES.include? self.status
  end
  
  def is_active?    
    !is_inactive?
  end
  
  def is_expired?
    self.period_ends_at < Time.now
  end
  
  def plans_to_upgrade
    self.subscription_plan.plans_to_upgrade
  end
  
  # Cancel the subscription on the Chargify end
  def cancel    
    unless self.status == 'canceled'
      ev = Event.create(
          :event_type     => :subscription,
          :event_subtype  => :cancel,
          :user           => self.user,
          :detail_i1      => self.id
      )      
      
      Rails::logger.debug "Calling chargify to cancel subscription ID #{self.chargify_id}"      
      Sherlock::Chargify.new.cancel(self.chargify_id)            
      
      Rails::logger.debug "Adjusting my own status to 'canceled'"      
      
      self.status = 'canceled'
      self.save
      
      ev.finish
      
      push_status_change_to_infusionsoft
    end
    
  end
  
  # When subscription is 'used', it means the user can't create any more cases 
  def is_used?
    self.cases_count == self.cases_max
  end
    
  def extra_case_created(c)
    self.extra_cases_count += 1
    save!
  end
  
  def case_created(c)
    self.cases_count += 1
    save!
  end
  
  private
  
  def push_status_change_to_infusionsoft
    InfusionsoftUtils.update_contact(self)
  end
    
end
