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
  
  def show
    @case = current_user.cases.find_by_id(params[:id])
  end
  
  def update
    @case = current_user.cases.find_by_id(params[:id])
    if @case
      respond_to do |format|
        if @case.update_attributes(params[:case])
          format.html { redirect_to(@case, :notice => 'Case has been successfully updated') }
        else
          format.html { render :action => 'edit' }
        end
      end
    end
  end
  
  def edit
    @case = current_user.cases.find_by_id(params[:id])
  end
  
  def index
    @cases = current_user.cases
  end

end
