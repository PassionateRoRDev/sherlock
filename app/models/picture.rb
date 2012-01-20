require 'digest/md5'

class Picture < ActiveRecord::Base
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
  
  def self.store(user, image)

    s = Time.now.to_i.to_s + rand(0..999).to_s
    hash = Digest::MD5.hexdigest(s)    

    filename = hash + '-' + image.original_filename
    
    dir = "#{Rails.root}/files/#{user.id}/pictures"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)    
    if File.directory?(dir)
      bytes = image.read
      filepath = dir + '/' + filename
      File.open(dir + '/' + filename, 'wb') {|f| f.write(bytes) }
    end
    
    filename
    
  end  
  
  def delete_file_for_path(filepath)
    #Rails::logger.debug("Removing file")
    user_id = self.block.case.user_id
    #Rails::logger.debug("user id: " + user_id.to_s)
    
    dir = "#{Rails.root}/files/#{user_id}/pictures"
    filepath = dir + '/' + self.path
    
    #Rails::logger.debug("Trying to remove the file: " + filepath)
    File.unlink(filepath) if File.exists?(filepath)
  end
  
  def delete_file
    delete_file_for_path(self.path)        
  end
  
  
  
end
