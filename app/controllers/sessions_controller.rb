class SessionsController < Devise::SessionsController
  
  def destroy
    if current_user
      
      Event.create( 
        :event_type => 'signout',
        :detail_i1  => current_user.id,
        :user_id    => current_user.id
      )
      
      KM.identify(current_user.id)      
      KM.record('Signed Out')
    end
    super
  end
  
end
