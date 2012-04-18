class ApplicationController < ActionController::Base
  
  protect_from_forgery

  helper_method :user_is_pi?
  
  rescue_from RailsAdmin::AccessDenied do |exception|
    redirect_to main_app.dashboard_path, 
      :alert => 'You are not authorized to view that page.'
  end
    
  def user_is_pi?
    (current_user && current_user.pi?)
  end  
  
  protected
    
  def after_sign_in_path_for(resource)
    KM.init_and_identify(current_user.id)    
    KM.record('signin')
    dashboard_path
  end
  
  def resolve_case_using_param(param)
    if current_user.admin
      @case = Case.find_by_id(params[param]) || redirect_to(cases_path)
    else    
      @case = current_user.find_case_by_id(params[param]) || redirect_to(cases_path)    
    end
  end
    
  def authorize_pi!
    redirect_to dashboard_path unless user_is_pi?
  end

  def authorize_for( object, atts = {})
    action = atts[:to] || :view
    redirect_to dashboard_path unless (action == :view && current_user && current_user.can_view?( object ))
  end 
end
