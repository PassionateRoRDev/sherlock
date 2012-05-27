class RegistrationsController < Devise::RegistrationsController
   
  def new
    if Setting.has_non_cc_trial?
      resource = build_resource(params)    
      resource.init_address if resource.respond_to?(:init_address)        
      respond_with resource    
    else
      redirect_to pricing_path
    end        
    
  end
  
  protected
  
  def after_sign_up_path_for(resource)
    
    logger.info 'Controller!!! after sign_up_path_for: user:'
    logger.info current_user
    
    if current_user      
      if current_user.pi?        
        current_user.setup_free_trial if Setting.has_non_cc_trial? && current_user.subscriptions.empty?
      end
        
      km_alias_identity_for current_user 
      
    end
    
    dashboard_path    
    
  end
  
  def km_get_identity_from_cookie
    cookies[:km_anon_identity]
  end
  
  def km_alias_identity_for(user)
    anonymous = km_get_identity_from_cookie    
    logger.info("Aliasing: #{anonymous} with #{user.id}")    
    KM.alias(anonymous, user.id) if anonymous      
  end
  
  def build_resource(hash=nil)        
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
  end
  

end
