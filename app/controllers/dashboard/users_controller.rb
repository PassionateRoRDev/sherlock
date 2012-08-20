class Dashboard::UsersController < DashboardController
  
  def index    
    @users = User.investigators.order('ID desc')    
  end
  
end
