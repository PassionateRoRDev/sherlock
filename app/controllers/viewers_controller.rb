class ViewersController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!

  before_filter :resolve_case
  
  def destroy        
    @viewer = current_company.clients.find_by_id(params[:id])
    if @viewer
      @case.viewers.delete(@viewer)
      @case.save     
    end
  end  
  
  protected
  
  def resolve_case
    resolve_case_using_param(:case_id)
  end
  
end
