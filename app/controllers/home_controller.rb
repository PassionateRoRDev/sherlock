class HomeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    
    @cases = current_user.cases
    
  end

end
