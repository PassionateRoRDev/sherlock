class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def resolve_case_using_param(param)
    @case = current_user.find_case_by_id(params[param]) || redirect_to(cases_path)    
  end
  
  
end
