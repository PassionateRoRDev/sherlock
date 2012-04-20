class PurchasesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!  
  
  def new    
    s = current_user.current_subscription
    @purchase = Purchase.new(:amount => s.extra_case_price)
  end
  
  def create    
    
    amount = params[:purchase][:amount]    
    current_user.purchases.create(
      :label  => :one_time_report,
      :amount => amount
    )    
    redirect_to new_case_path
    
  end
  
end