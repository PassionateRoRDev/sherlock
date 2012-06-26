class EmailReminder

  def process_free_trial_1_week_left
    result = []
    expiring_on = Time.now + 1.week        
    Subscription.free_trials.expiring_on(expiring_on).each do |subscription|      
      user = subscription.user
      unless subscription.sent_emails.find_by_label(:free_trial_1_week)
        result << PostOffice.free_trial_1_week(FreeTrialPresenter.new(user)).deliver
        subscription.sent_emails << SentEmail.new(:label => :free_trial_1_week)
      end      
    end
    result
  end
  
  def process_free_trial_4_days_left    
    result = []
    expiring_on = Time.now + 4.days
    Subscription.free_trials.expiring_on(expiring_on).each do |subscription|
      user = subscription.user
      unless subscription.sent_emails.find_by_label(:free_trial_4_days)
        result << PostOffice.free_trial_4_days(FreeTrialPresenter.new(user)).deliver
        subscription.sent_emails << SentEmail.new(:label => :free_trial_4_days)
      end      
    end
    result
  end
  
  def process_free_trial_expire_today    
    result = []
    expiring_on = Time.now
    Subscription.free_trials.expiring_on(expiring_on).each do |subscription|
      user = subscription.user
      unless subscription.sent_emails.find_by_label(:free_trial_expiration)        
        result << PostOffice.free_trial_expiration(FreeTrialPresenter.new(user)).deliver
        subscription.sent_emails << SentEmail.new(:label => :free_trial_expiration)
      end      
    end
    result
  end
    
end
