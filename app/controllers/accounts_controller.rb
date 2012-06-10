class AccountsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_pi!

  def show
    
    @account = current_user
    @account.user_address ||= @account.init_address 
    
    @my_subscription  = current_user.current_subscription
    @my_plan          = current_user.current_plan
    @one_time_credits = current_user.unused_purchases
    
    @should_upgrade = @my_subscription && @my_subscription.is_used?
    @expired = @my_subscription && @my_subscription.is_expired?
    
    @renew = @my_subscription && (@my_subscription.is_expired? || @my_subscription.is_inactive?)
    
    @cases = current_user.authored_cases
    
  end
  
  def renew    
    renew_or_upgrade    
  end
  
  def upgrade    
    renew_or_upgrade    
  end

  def update
    
    # remove password / password confirmation if blank
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    @account = current_user

    if( @account.update_attributes( params[:user] ))
      notice = "Information Updated"
      redirect_to dashboard_path, :notice => notice
    else
      render :action => 'show'
    end
  end
  
  private
  
  def renew_or_upgrade
    
    @current_user = current_user
    @plans        = current_user.plans_to_upgrade
    @current_plan = current_user.current_plan
    
    
    @subscription = current_user.current_subscription
    
    @subscription_inactive  = @subscription && @subscription.is_inactive?    
    @subscription_expired   = @subscription && @subscription.is_expired?    
    
    render 'cases/upgrade_or_purchase'
    
  end
  
end

