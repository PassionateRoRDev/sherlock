#
# Controller that will be used to serve files with proper access control
#
class FilesController < ApplicationController
  
  before_filter :authenticate_user!

  def video_thumbnail
    
    type      = 'videos'
    filename  = params[:filename]
    kase      = resolve_case
    owner = kase.nil? ? resolve_owner(type, filename) : kase.author
    
    return redirect_to root_path unless owner
    
    asset = kase.video_thumbnail_by_path(filename)
        
    return redirect_to root_path unless asset
    
    options = {}        
    
    options[:content_type]  = asset.content_type if asset.content_type
    options[:disposition]   = 'inline'
    
    path = asset.full_filepath
    
    send_file(path, options)
    
  end
  
  def show

    type      = params[:type]
    filename  = params[:filename]
    
    kase = resolve_case
    owner = kase.nil? ? resolve_owner(type, filename) : kase.author
    
    return redirect_to root_path unless owner
    
    asset = resolve_asset(kase, owner, filename, type)
    
    path = asset.full_filepath
    return redirect_to root_path unless File.exists?(path)
    
    options = {}        
    if asset    
      options[:content_type]  = asset.content_type if asset.content_type
      options[:disposition]   = 'inline'
    end    
    send_file(path, options)
        
  end
  
  private
  
  def resolve_asset(kase, owner, filename, type)
    case type
    when 'pictures'
      kase.pictures.find_by_path(filename)
    when 'videos'
      kase.videos.find_by_path(filename)
    when 'logos'
      owner.logos.find_by_path(filename)      
    else
      nil
    end
  end
   
  def resolve_case
    if current_user.admin
      Case.find_by_id params[:case_id]
    else    
      current_user.find_case_by_id params[:case_id]
    end
  end
  
  def resolve_owner(type, filename)    
    owner = nil    
    if type == 'logos'
      user = current_user    
      if user.admin
        logo = Logo.find_by_path(filename)
        owner = logo.user if logo
      elsif user.pi?
        user
      else
        logo = Logo.find_by_path(filename)
        owner = logo.user if logo && logo.user.clients.include?(user)          
      end
    end    
    owner    
  end
  
end
