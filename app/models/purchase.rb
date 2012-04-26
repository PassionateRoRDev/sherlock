class Purchase < ActiveRecord::Base
  
  belongs_to :user

  validate :make_chargify_call, :on => :create
  
  def use_up_for_case(kase)
    self.used_at          = Time.now
    self.used_by_case_id  = kase.id
    self.save!    
  end
  
  private
  
  def make_chargify_call
    
    current = self.user.current_subscription
    
    ev = Event.create(
      :event_type     => :purchase,
      :event_subtype  => :one_time_report,
      :user           => self.user,
      :detail_i1      => current.id
    )
    
    Rails::logger.debug "Making the chargify call using subscription ID #{current.chargify_id}"
    
    memo = 'Pay per-use for a single report'
    
    #s = Chargify::Subscription.find(current.chargify_id)    
    #s.charge(:amount => self.amount, :memo => memo)
    
    chargify = Sherlock::Chargify.new
    chargify.charge(current.chargify_id, self.amount, memo)
    
    Rails::logger.debug 'Chargify errors:'
    Rails::logger.debug chargify.errors
    
    if chargify.errors
      chargify.errors.each do |err|
        self.errors.add(:purchase, err)
      end
    end
    
    ev.detail_s2 = chargify.response_code
    ev.finish
    
  end
  
end
