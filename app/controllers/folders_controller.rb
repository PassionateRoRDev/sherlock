class FoldersController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :authorize_pi!, :except => [ :show ]
  
  before_filter :resolve_folder, :except => [ :new, :create ]
  
  def new  
    @folder = current_user.folders.new    
  end
  
  def create
    
    @folder = current_user.folders.new(params[:folder])
    if @folder.save
      redirect_to cases_path
    else
      
    end
    
  end
  
  def destroy
    @folder.destroy if @folder
    redirect_to cases_path
  end
  
  def show    
    @cases = current_user.cases.select { |c| c.folder == @folder }
  end
  
  private
  
  def resolve_folder
    @folder = current_user.folders.find_by_id(params[:id]) || redirect_to(cases_path)
  end  
  
end