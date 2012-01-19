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
    @case = resolve_case_from_id
  end
  
  def update
    @case = resolve_case_from_id
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
  
  def destroy
    @case = resolve_case_from_id
    @case.destroy
    
    respond_to do |format|
      format.html { redirect_to(cases_path, :notice => 'The case was successfully deleted') }
    end
    
  end
  
  def edit
    @case = resolve_case_from_id
  end
  
  def index
    @cases = current_user.cases
  end
  
  private
  
  def resolve_case_from_id
    the_case = current_user.cases.find_by_id(params[:id])
    the_case ? the_case : redirect_to(cases_path)
  end

end
