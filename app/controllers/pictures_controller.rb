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
    @insert_before_id = params[:insert_before_id].to_i
    
    @cookie = cookies['_sherlock_session']
    
  end
  
  def create
           
    image = params[:upload] ? params[:upload]['image'] : nil
            
    if image          
      params[:picture][:original_filename] = image.original_filename
      params[:picture][:content_type] = image.content_type    
      file_path = Picture.store(current_user, image)
      params[:picture][:path] = file_path
    end      
    
    @picture = Picture.new(params[:picture])
    block = Block.new(:case => @case)    
    @insert_before_id = params[:insert_before_id].to_i
    block.insert_before_id = @insert_before_id    
    @picture.block = block          
        
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
    
    params[:upload] ||= {}
    image = params[:upload]['image']
    
    if image    
      params[:picture][:original_filename] = image.original_filename
      params[:picture][:content_type] = image.content_type              
    end
    
    respond_to do |format|
      if @picture.update_attributes(params[:picture])                        
                
        if image
          logger.debug("Deleting the previous file")
          @picture.delete_file
          @picture.path = Picture.store(current_user, image)
          @picture.save
        end
        
        format.html { redirect_to(@case, :notice => 'The block has been successfully updated') }
      else
        format.html { render :action => 'edit' }
      end
    end
    
  end
  
  private
  
  def resolve_case
    resolve_case_using_param(:case_id)
  end
  
end
