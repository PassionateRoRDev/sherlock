class ApplicationController < ActionController::Base
  
  protect_from_forgery

  helper_method :user_is_pi?
  
  before_filter :km_init_anonymous
  
  rescue_from RailsAdmin::AccessDenied do |exception|
    redirect_to main_app.dashboard_path, 
      :alert => 'You are not authorized to view that page.'
  end
    
  def user_is_admin?
    (current_user && current_user.admin)
  end  
  
  def user_is_pi?
    (current_user && current_user.pi?)
  end  
  
  protected
      
  def km_get_identity_from_cookie
    cookies[:km_anon_identity]
  end
  
  def km_set_identity_cookie(request)
    id = Kissmetrics.generate_anonymous_id request
    cookies[:km_anon_identity] = {
      :value => id, :expires => 5.years.from_now
    }
  end
  
  def km_init_anonymous       
    km_set_identity_cookie(request) unless km_get_identity_from_cookie    
    logger.info 'IDENTITY:'
    logger.info km_get_identity_from_cookie
    @km_visitor_id = km_get_identity_from_cookie
    KM.identify(@km_visitor_id)
  end
  
  def km_alias_identity_for(user)
    anonymous = km_get_identity_from_cookie    
    logger.info("Aliasing: #{anonymous} with #{user.id}")    
    KM.alias(anonymous, user.id) if anonymous      
  end
  
  def after_sign_up_path_for(resource)
    
    logger.info 'Controller: after sign_up_path_for: user:'
    logger.info current_user
    
    km_alias_identity_for current_user if current_user
    dashboard_path    
  end
  
  def after_sign_in_path_for(resource)
    
    logger.debug 'Controller: after sign_up_path_for: user:'
    logger.debug current_user    
    
    if current_user      
      Event.create( 
        :event_type => 'signin',      
        :detail_i1  => current_user.id,
        :user_id    => current_user.id
      )      
      km_alias_identity_for current_user
      KM.identify current_user.id
      KM.record 'Signed In'
    end
    dashboard_path
  end    
  
  def resolve_case_using_param(param)
    if current_user.admin
      @case = Case.find_by_id(params[param]) || redirect_to(cases_path)
    else    
      @case = current_user.find_case_by_id(params[param]) || redirect_to(cases_path)    
    end
  end
    
  def authenticate_admin!
    redirect_to dashboard_path unless user_is_admin?
  end
  
  def authorize_pi!
    redirect_to dashboard_path unless user_is_pi?
  end

  def authorize_for( object, atts = {})
    action = atts[:to] || :view
    redirect_to dashboard_path unless (action == :view && current_user && current_user.can_view?( object ))
  end 
end
