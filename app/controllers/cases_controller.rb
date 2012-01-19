class CasesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def new
    @case = Case.new
  end
  
  def create
    
    @case = Case.new(params[:case])
    @case.user = current_user
    respond_to do |format|
      if (@case.save) 
        format.html { redirect_to(cases_path, :notice => 'Case has been successfully created') }
      else  
        format.html { render :action => 'new' }
      end
    end        
    
  end
  
  def index
    @cases = current_user.cases
  end

end
