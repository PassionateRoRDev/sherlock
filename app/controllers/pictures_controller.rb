class PicturesController < ApplicationController
  
  before_filter :authenticate_user!
  
  #
  # Note: we may want to remove it, if this controller will also be
  #       used to upload pictures unlinked with any blocks/cases
  #
  before_filter :resolve_case, :only => [ :new, :edit, :update, :create ]
  
  def new
    
    block = Block.new
    block.case = @case
    @picture  = Picture.new(:block => block)    
    
  end
  
  def create
    
    logger.debug("Deleting the 'image'")
    params[:picture].delete('image')
    
    params[:picture][:path] = '1.png'
    
    logger.debug(params[:picture])
    
    @picture = Picture.new(params[:picture])
    block = Block.new(:case => @case)    
    @picture.block = block
    
    # TODO: initialize weight to be the maximum one    
        
    respond_to do |format|
      if (@picture.save) 
        format.html { redirect_to(@case, :notice => 'Picture block has been added') }
      else  
        format.html { render :action => 'new' }
      end
    end        
    
  end
  
  def edit
    @picture = @case.pictures.find_by_id(params[:id])
    redirect_to cases_path unless @picture
    
  end
  
  def update
    @picture = @case.pictures.find_by_id(params[:id])    
    redirect_to cases_path unless @picture
    
    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to(@case, :notice => 'The block has been successfully updated') }
      else
        format.html { render :action => 'edit' }
      end
    end
    
  end
  
  private
  
  def resolve_case
    @case = current_user.cases.find_by_id(params[:case_id]) || 
      redirect_to(cases_path)      
  end
  
end