class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from RailsAdmin::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => 'You are not authorized to view that page.'
  end
  
  protected
  
  def resolve_case_using_param(param)
    @case = current_user.find_case_by_id(params[param]) || redirect_to(cases_path)    
  end

  def authorize_for( object, atts = {})
    action = atts[:to] || :view

    go_away unless action == :view && current_user && current_user.can_view?( object )
  end 
end
