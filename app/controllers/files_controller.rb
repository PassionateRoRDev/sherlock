#
# Controller that will be used to serve files with proper access control
#
class FilesController < ApplicationController
  
  before_filter :authenticate_user!

  def show()

    type      = params[:type]
    filename  = params[:filename]
    
    user = current_user
    path = "#{Rails.root}/files/#{user.id}/#{type}/" + filename
    return redirect_to root_path unless File.exists?(path)
    
    options = {}
    
    asset = nil
    
    case type
    when 'pictures'
      asset = user.pictures.find_by_path(filename)
    when 'videos'
      asset = user.videos.find_by_path(filename)
    when 'logos'
      asset = user.logos.find_by_path(filename)
    end
    
    if asset    
      options[:content_type]  = asset.content_type if asset && asset.content_type
      options[:disposition]   = 'inline'
    end
    
    send_file(path, options)
        
  end
  
end