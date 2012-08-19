class PicturesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  #
  # Note: we may want to remove it, if this controller will also be
  #       used to upload pictures unlinked with any blocks/cases
  #
  before_filter :resolve_case, :only => [ :new, :edit, :show, :update, :create ]
  
  before_filter :verify_case_author!, :only => [ :new, :edit, :update, :create ]
  
  def new
    
    block = Block.new
    block.case = @case
    @picture  = Picture.generate(block)
    
    @insert_before_id = params[:insert_before_id].to_i    
    @cookie = cookies['_sherlock_session']
    
  end
  
  def create
    
    params[:picture][:user] = current_user       
    
    image = params[:upload] ? params[:upload]['image'] : nil    
    params[:picture][:uploaded_file] = image if image    
        
    @picture = Picture.new(params[:picture])
    block = Block.new(:case => @case)    
    @insert_before_id = params[:insert_before_id].to_i
    block.insert_before_id = @insert_before_id    
    @picture.block = block          
        
    respond_to do |format|
      if (@picture.save) 
        format.html { redirect_to(@case, :notice => 'Picture block has been added') }
      else        
        format.html do
          flash[:alert] = 'Picture could not be saved'
          render :action => 'new'           
        end
      end
    end        
    
  end
  
  def edit
    @insert_before_id = 0
    @picture = @case.pictures.find_by_id(params[:id])
    @cookie = cookies['_sherlock_session']
    redirect_to cases_path unless @picture
    
  end
  
  def show
    @picture = @case.pictures.find_by_unique_code(params[:id])
    respond_to do |format|
      format.js { render :json => @picture }
    end
  end
  
  def update
    
    @picture = @case.pictures.find_by_id(params[:id])    
    redirect_to cases_path unless @picture
    
    params[:upload] ||= {}
    image = params[:upload]['image']
    
    params.delete(:crop) if params[:crop] == ["", "", "", ""]
    
    logger.debug 'Params crop:'
    logger.debug params[:crop]
    
    if params[:crop]
      if (params[:crop_new_block].to_i == 1)
        @case.create_block_from_picture(@picture, params[:crop])
      else
        @picture.crop(params[:crop])
      end
    end
    
    respond_to do |format|      
      params[:picture][:uploaded_file] = image if image      
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to @case, 
                      :notice => 'The block has been successfully updated' }                
      else
        format.html do 
          flash[:alert] = 'The block has not been updated'
          render :action => 'edit'          
        end
      end
    end
    
  end
  
  private
    
  def resolve_case
    resolve_case_using_param(:case_id)
  end
  
  def verify_case_author!    
    is_author = (@case.author == current_user)
    redirect_to @case unless is_author    
  end
  
end
