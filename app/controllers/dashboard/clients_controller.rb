class Dashboard::ClientsController < DashboardController
  
  def index
    @users = User.clients.order('ID desc')
  end      
  
end
