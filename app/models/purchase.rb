class Purchase < ActiveRecord::Base
  
  belongs_to :user

  before_create :make_chargify_call
  
  private
  
  def make_chargify_call    
    s = Chargify::Subscription.find(self.user.current_subscription.chargify_id)    
    memo = 'Pay per-use for a single report'
    s.charge(:amount => self.amount, :memo => memo)
  end
  
end
