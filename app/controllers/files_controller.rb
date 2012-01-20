#
# Controller that will be used to serve files with proper access control
#
class FilesController < ApplicationController
  
  before_filter :authenticate_user!

  def show()

    type      = params[:type]
    filename  = params[:filename]
    
    content_type = nil
    
    user = current_user
    path = "#{Rails.root}/files/#{user.id}/#{type}/" + filename
    return redirect_to root_path unless File.exists?(path)
    
    options = {}
    
    case type
    when 'pictures'
      options[:content_type]  = 'image/png'
      options[:disposition]   = 'inline'
    end
    
    send_file(path, options)
        
  end
  
end