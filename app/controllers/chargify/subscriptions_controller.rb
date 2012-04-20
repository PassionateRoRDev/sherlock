class Chargify::SubscriptionsController < ApplicationController
  
  def new 
    
    return redirect_to dashboard_path unless params[:subscription_id]
        
    if ::Subscription.find_by_chargify_id(params[:subscription_id])
      logger.info 'The subscription already exists - ignore'
      redirect_to dashboard_path
    else
    
      begin
        @subscription = Chargify::Subscription.find(params[:subscription_id])
        if @subscription        
          user = User.create_from_chargify_subscription(@subscription)        
          if user
            if user.is_new
              logger.info("New user purchased a subscription")
              user.send_welcome_message        
              sign_in(:user, user)
            else
              logger.info("Existing user purchased a subscription")
            end
            redirect_to dashboard_path
          else
            logger.error('No user found!')
            render_error
          end
        else
          logger.error('No subscription found!')
          render_error
        end
      rescue
        render_error
      end
      
    end
  end
  
  private 
  
  def render_error
    render 'subscriptions/chargify_error'
  end
  
end
