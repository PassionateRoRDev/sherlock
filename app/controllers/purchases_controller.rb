class PurchasesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!  
  
  def new    
    s = current_user.current_subscription
    
    if s.extra_case_price.to_i == 0
      redirect_to new_case_path
    else
      @purchase = Purchase.new(:amount => s.extra_case_price)    
    end
    
    
  end
  
  def create    
    amount = params[:purchase][:amount]   
    @purchase = current_user.purchases.new(
      :label  => :one_time_report,
      :amount => amount
    )    
    if @purchase.save           
      redirect_to new_case_path
    else     
      Rails::logger.error 'Purchase create failed!'      
      render 'new'
    end
    
  end
  
end