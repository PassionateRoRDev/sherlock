class Dashboard::UsersController < DashboardController
  
  def index
    
    @users = User.where(:invitation_accepted_at => nil, :invitation_token => nil).order('ID desc')
    
  end
  
end
