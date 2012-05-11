class UserObserver < ActiveRecord::Observer

  observe User

  def after_create(user)        
    unless user.invitation_token
      Event.create( 
        :event_type => 'signup',      
        :detail_i1  => user.id,
        :user_id    => user.id
      )      
      Rails::logger.debug('Sending data to kissmetrics')
      KM.identify(user.id)  
      KM.record('Signed Up')  
      Rails::logger.debug('Data sent')
    end
    
  end
  
end
