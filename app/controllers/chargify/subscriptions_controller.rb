class Chargify::SubscriptionsController < ApplicationController
  
  def new  
    
    subscription = Chargify::Subscription.find(params[:subscription_id])
    if subscription
      
      plan = SubscriptionPlan.find_by_chargify_handle(subscription.product.handle)
      
      customer = subscription.customer
      password = User.generate_random_password(10)
      
      user = User.find_or_create_by_email(
        :email                  => customer.email,
        :first_name             => customer.first_name,
        :last_name              => customer.last_name,
        :company_name           => customer.organization,
        :password               => password, 
        :password_confirmation  => password
      )
      
      user.subscriptions << ::Subscription.find_or_create_by_chargify_id(
        :chargify_id        => subscription.id,
        :product_handle     => plan.chargify_handle,
        :subscription_plan  => plan,
        :period_ends_at     => subscription.current_period_ends_at,
        :next_assessment_at => subscription.next_assessment_at,
        :status             => subscription.state,
        
        :cases_max          => plan.cases_max,
        :cases_count        => 0,
        :clients_max        => plan.clients_max,
        :clients_count      => 0,
        :storage_max_mb     => plan.storage_max_mb,
        
        :extra_case_price   => plan.extra_case_price,
        :extra_cases_count  => 0
      )
      
    end
    
    render :text => 1    
    
  end
  
end
