class Purchase < ActiveRecord::Base
  
  belongs_to :user

  before_create :make_chargify_call
  
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
    
    s = Chargify::Subscription.find(current.chargify_id)
    memo = 'Pay per-use for a single report'
    s.charge(:amount => self.amount, :memo => memo)
    
    ev.finish
    
  end
  
end
