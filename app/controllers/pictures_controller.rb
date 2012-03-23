class PicturesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  #
  # Note: we may want to remove it, if this controller will also be
  #       used to upload pictures unlinked with any blocks/cases
  #
  before_filter :resolve_case, :only => [ :new, :edit, :show, :update, :create ]
  
  def new
    
    block = Block.new
    block.case = @case
    @picture  = Picture.generate(block)
    @insert_before_id = params[:insert_before_id].to_i    
    @cookie = cookies['_sherlock_session']
    
  end
  
  def create
           
    image = params[:upload] ? params[:upload]['image'] : nil
    
    params[:picture].merge!(handle_image_upload(image)) if image
    
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
    
    if image    
      params[:picture][:original_filename] = image.original_filename
      params[:picture][:content_type] = image.content_type              
    else
      if (params[:crop_new_block].to_i == 1)
        @case.create_block_from_picture(@picture, params[:crop])
      else
        @picture.crop(params[:crop])
      end      
    end
    
    respond_to do |format|      
      error = true     
      if @picture.update_attributes(params[:picture])                                
        error = false
        if image
          logger.debug 'Storing the picture'
          new_filepath = Picture.store(current_user, image)
          logger.debug new_filepath.to_s
          if new_filepath.present?                      
            @picture.delete_files
            @picture.path = new_filepath            
            error = ! @picture.save                                    
          end
        end
      end
      
      pp error
      
      if error
        format.html do 
          flash[:alert] = 'The block has not been updated'
          render :action => 'edit'          
        end        
      else
        format.html { redirect_to @case, 
                      :notice => 'The block has been successfully updated' }        
      end
    end
    
  end
  
  private
  
  def handle_image_upload(image)   
    {
      :original_filename  => image.original_filename,
      :content_type       => image.content_type,
      :path               => Picture.store(current_user, image)
    }    
  end
  
  def resolve_case
    resolve_case_using_param(:case_id)
  end
  
end
