class RegistrationsController < Devise::RegistrationsController
   
  def new    
    if User::BETA_PERIOD
      resource = build_resource(params)    
      resource.init_address if resource.respond_to?(:init_address)        
      respond_with resource    
    else
      redirect_to pricing_path
    end        
    
  end
  
  protected
  
  def build_resource(hash=nil)        
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
  end
  

end
