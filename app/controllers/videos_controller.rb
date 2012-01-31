class VideosController < ApplicationController
  
  before_filter :authenticate_user!
  
  #
  # Note: we may want to remove it, if this controller will also be
  #       used to upload videos unlinked with any blocks/cases
  #
  before_filter :resolve_case, :only => [ :new, :edit, :update, :create ]
  
  def new
    
    block = Block.new
    block.case = @case
    @video  = Video.new(:block => block)    
    
  end
  
  def create
    
    video = params[:upload]['video']
    thumbnail = params[:upload]['thumbnail']
    
    logger.debug(video)
    logger.debug('Thumbnail')
    logger.debug(thumbnail)
    
    params[:video][:original_filename] = video.original_filename
    params[:video][:content_type] = video.content_type    
            
    paths = Video.store(current_user, video, thumbnail)
    
    params[:video][:path] = paths[:video_filename]
    params[:video][:thumbnail] = paths[:thumbnail_filename]
    
    @video = Video.new(params[:video])
    block = Block.new(:case => @case)    
    @video.block = block
    
    # TODO: initialize weight to be the maximum one    
        
    respond_to do |format|
      if (@video.save) 
        format.html { redirect_to(@case, :notice => 'Video block has been added') }
      else  
        format.html { render :action => 'new' }
      end
    end        
    
  end
  
  def edit
    @video = @case.videos.find_by_id(params[:id])
    redirect_to cases_path unless @video
    
  end
  
  def update
    @video = @case.videos.find_by_id(params[:id])    
    redirect_to cases_path unless @video
    
    old_path = @video.path
    
    respond_to do |format|
      if @video.update_attributes(params[:video])                        
        video = params[:upload]['video']
        if video
          logger.debug("Deleting the previous file")
          @video.delete_file_for_path(old_path)
          @video.path = Video.store(current_user, video)
          @video.save
        end
        
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
