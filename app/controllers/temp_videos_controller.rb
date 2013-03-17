class TempVideosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_pi!

  skip_before_filter :verify_authenticity_token
  
  def create
            
    temp_video = TempVideo.new do |video|        
      video.upload  = params[:upload][:video]
      video.user_id = current_company.id     
    end
    temp_video.save
        
    respond_to do |format|
      format.html
      format.js
    end
    
  end
  
end
