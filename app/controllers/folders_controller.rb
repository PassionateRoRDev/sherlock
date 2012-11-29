class FoldersController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :authorize_pi!, :except => [ :show ]
  
  before_filter :resolve_folder, :except => [ :new, :create ]
  
  def new  
    @folder = current_company.folders.new    
  end
  
  def create
    
    @folder = current_company.folders.new(params[:folder])
    if @folder.save
      redirect_to cases_path
    else
      
    end
    
  end
  
  def destroy
    @folder.destroy if @folder
    redirect_to cases_path
  end
  
  def update
    
    respond_to do |format|      
      if @folder.update_attributes(params[:folder])
        format.html { redirect_to cases_path, :notice => 'Folder has been successfully updated' }
        format.js
      else
        foreat.html { render :action => 'edit' }
        format.js
      end   
    end
    
  end
  
  def edit
    
  end
  
  def show    
    @cases = current_company.cases.select { |c| c.folder == @folder }    
    @cases_to_move = current_company.cases.select { |c| c.folder != @folder }   
  end
  
  def move_out_case
    
    @case = resolve_case_using_param :case_id
    @case.move_toplevel if @case
    redirect_to @folder, :notice => 'Case was successfully moved'    
  end
  
  def move_case    
    @case = resolve_case_using_param :case_id
    @case.move_to_folder @folder if @case    
    redirect_to @folder, :notice => 'Case was successfully moved'    
  end
  
  private
  
  def resolve_folder
    @folder = current_company.folders.find_by_id(params[:id]) || redirect_to(cases_path)
  end  
  
end