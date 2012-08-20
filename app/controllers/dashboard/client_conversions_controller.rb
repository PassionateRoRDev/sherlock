class Dashboard::ClientConversionsController < DashboardController
  
  before_filter :resolve_client, :only => [ :new, :create ]
  
  def new    
  end
  
  def create
    @client.setup_free_trial if Setting.has_non_cc_trial?    
    redirect_to dashboard_users_path, :notice => "Client #{@client.email} converted to PI"
  end
  
  private
  
  def resolve_client
    @client = User.find(params[:client_id])
    @client = nil if @client.pi?
    redirect_to dashboard_clients_path unless @client
  end
  
end
