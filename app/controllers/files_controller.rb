#
# Controller that will be used to serve files with proper access control
#
class FilesController < ApplicationController
  
  before_filter :authenticate_user!

  def show()

    type      = params[:type]
    filename  = params[:filename]
    
    kase = resolve_case    
    owner = kase.nil? ? resolve_owner(type, filename) : kase.author
    
    return redirect_to root_path unless owner
    
    path = "#{Rails.root}/files/#{owner.id}/#{type}/" + filename    
    return redirect_to root_path unless File.exists?(path)
    
    options = {}
    
    asset = nil
    
    case type
    when 'pictures'
      asset = kase.pictures.find_by_path(filename)
    when 'videos'
      asset = kase.videos.find_by_path(filename)
      unless asset
        # try based on the file extension
        filename =~ /([^.]+)$/
        Rails::logger.debug('Extension:')
        Rails::logger.debug($1)
        case $1
        when 'ogv'
          options[:content_type] = 'video/ogg'
          options[:disposition] = 'inline'        
        when 'flv'
          options[:content_type] = 'video/x-flv'
          options[:disposition] = 'inline'
        when 'm4v'
          options[:content_type] = 'video/mp4'
          #options[:disposition] = 'inline'
        when 'mp4'
          options[:content_type] = 'video/mp4'        
        end    
      end
    when 'logos'
      asset = owner.logos.find_by_path(filename)
    end
    
    if asset    
      options[:content_type]  = asset.content_type if asset && asset.content_type
      options[:disposition]   = 'inline'
    end
    
    #Rails::logger.debug(options)
    
    send_file(path, options)
        
  end
  
  private
   
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
