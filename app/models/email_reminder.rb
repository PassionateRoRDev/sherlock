class EmailReminder

  def process_free_trial_1_week_left
    process(Time.now + 1.week, :free_trial_1_week) do |user|
      pp "Sending 1 week reminder to user: #{user.email} (#{user.id})"
      #pp user
      PostOffice.free_trial_1_week(FreeTrialPresenter.new(user)).deliver
    end        
  end
  
  def process_free_trial_4_days_left    
    process(Time.now + 4.days, :free_trial_4_days) do |user|
      pp "Sending 4 days reminder to user: #{user.email} (#{user.id})"
      #pp user
      PostOffice.free_trial_4_days(FreeTrialPresenter.new(user)).deliver
    end        
  end
  
  def process_free_trial_expire_today    
    process(Time.now, :free_trial_expiration) do |user|
      pp "Sending expiration reminder to user: #{user.email} (#{user.id})"
      #pp user
      PostOffice.free_trial_expiration(FreeTrialPresenter.new(user)).deliver
    end        
  end
  
  private
  
  def process(expiring_on, label)    
    expiring = Subscription.free_trials.expiring_on(expiring_on)
    expiring.all.select { |s| !s.sent_emails.find_by_label(label) }.map do |s|
      email_sent = yield(s.user)
      rec = SentEmail.new(:label => label)
      s.sent_emails << rec
      s.user.sent_emails << rec
      email_sent
    end        
  end
    
end
