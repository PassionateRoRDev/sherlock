class ImpersonationsController < ApplicationController

  before_filter :authenticate_admin!
   
  def new
    
  end
  
  def create    
    user = User.find_by_id params[:user_id]    
    sign_in(:user, user) if user    
    redirect_to dashboard_path    
  end  

end
