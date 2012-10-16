class Dashboard::BlockedIpsController < DashboardController
  
  def index    
    @blocked_ips = BlockedIp.all    
  end
  
  def new
    @blocked_ip = BlockedIp.new
  end
  
  def create
    @blocked_ip = BlockedIp.new(params[:blocked_ip])
    respond_to do |format|
      if @blocked_ip.save
        format.html { redirect_to(dashboard_blocked_ips_path, :notice => 'The IP was added to the list') }
      else        
        format.html { render :action => 'new' }      
      end
    end
  end
  
  def destroy
    @ip = BlockedIp.find(params[:id])    
    @ip.destroy if @ip    
    respond_to do |format|
      format.html { redirect_to(dashboard_blocked_ips_path, :notice => 'The IP was removed from the list') }
      format.js
    end
    
  end
  
end
