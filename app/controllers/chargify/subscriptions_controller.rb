class Chargify::SubscriptionsController < ApplicationController
  
  #
  # TODO: implement graceful error handling
  # 
  # - no subcription found
  # - no plan found
  # - user not created/returned
  #
  def new      
    @subscription = Chargify::Subscription.find(params[:subscription_id])
    if @subscription
      user = User.create_from_chargify_subscription(@subscription)
      if user        
        user.send_welcome_message        
        sign_in(:user, user)
        redirect_to dashboard_path
      else
        render 'error'
      end
    else
      render 'error'
    end
  end
  
end
