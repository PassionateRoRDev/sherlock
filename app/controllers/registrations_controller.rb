class RegistrationsController < Devise::RegistrationsController

  def new    
    resource = build_resource(params)    
    resource.init_address if resource.respond_to?(:init_address)        
    respond_with resource    
  end
  
  protected
  
  def build_resource(hash=nil)
    
    Rails::logger.debug("PARAMS:")
    Rails::logger.debug(params)
    
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
  end
  

end
