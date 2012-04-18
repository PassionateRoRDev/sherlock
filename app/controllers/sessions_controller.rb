class SessionsController < Devise::SessionsController
  
  def destroy
    if current_user
      KM.identify(current_user.id.to_s)
      KM.record('signout')
    end
    super
  end
  
end
