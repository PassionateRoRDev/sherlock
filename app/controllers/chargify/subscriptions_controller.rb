class Chargify::SubscriptionsController < ApplicationController
  
  def new      
    @subscription = Chargify::Subscription.find(params[:subscription_id])
    if @subscription
      user = User.create_from_chargify_subscription(@subscription)
      if user
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
