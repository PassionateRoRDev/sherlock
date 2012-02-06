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
    @video  = Video.new(:block => block, :thumbnail_pos => '00:00:01')    
  end
  
  def create
    
    params[:upload] = {} unless params[:upload]
    
    if params[:video][:thumbnail_method] == 'auto'
      params[:upload].delete('thumbnail')
    end    
    params[:video].delete(:thumbnail_method)
       
    video     = params[:upload]['video']
    thumbnail = params[:upload]['thumbnail']
            
    if video
    
      params[:video][:original_filename] = video.original_filename
      params[:video][:content_type]      = video.content_type    

      video_filename = Video.store(current_user, video)
      params[:video][:path] = video_filename

      # store thumbnail or automatically generate a new one:
      thumbnail_info = {}

      logger.debug('Thumbnail is:')
      logger.debug(thumbnail)

      if thumbnail
        thumbnail_info = 
          Video.store_thumbnail(current_user.id, video_filename, thumbnail)
        params[:video].delete(:thumbnail_pos)
      else
        thumbnail_info =
          Video.extract_thumbnail_from_movie(current_user.id, video_filename, 
                                             params[:video][:thumbnail_pos])
      end    

      params[:video][:thumbnail]  = thumbnail_info[:filename]    
      params[:video][:width]      = thumbnail_info[:width]
      params[:video][:height]     = thumbnail_info[:height]
        
    end
      
    @video = Video.new(params[:video])
    block = Block.new(:case => @case)    
    @video.block = block
    logger.debug("Recoding to FLV")    
    
    respond_to do |format|
      if (@video.save) 
        @video.recode_to_flv
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
    
    thumbnail_method = params[:video][:thumbnail_method]
    
    if params[:upload] && (params[:video][:thumbnail_method] == 'auto')
      params[:upload].delete('thumbnail')
    end    
    params[:video].delete(:thumbnail_method)    
    
    respond_to do |format|
      if @video.update_attributes(params[:video])        
        video = params[:upload] ? params[:upload]['video'] : nil
        if video
          video_filename = Video.store(current_user, video)                    
          @video.delete_file
          @video.path = video_filename
          @video.rename_thumbnail if @video.thumbnail
          @video.recode_to_flv
          @video.save
        end
        
        unless params[:keep_thumbnail].to_i == 1
          
          case thumbnail_method
          when 'auto'
            logger.debug('Extracting the thumbnail automatically!')
            Video.extract_thumbnail_from_movie(current_user.id, @video.path, 
                                               @video.thumbnail_pos)
          when 'manual'
            if params[:upload] && params[:upload]['thumbnail']
              logger.debug('Updating the thumbnail manually!')
              thumbnail = params[:upload]['thumbnail']
              thumbnail_info = 
                Video.store_thumbnail(current_user.id, @video.path, thumbnail)              
              @video.thumbnail_pos  = nil
              @video.width          = thumbnail_info[:width]
              @video.height         = thumbnail_info[:height]
              @video.save
            end
          end
          
        else
          logger.debug("Keeping the thumbnail!!!!")
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
