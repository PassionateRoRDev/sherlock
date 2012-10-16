class BlockedIp < ActiveRecord::Base
  
  validates :ip, :presence => true 
  validates :ip, :uniqueness => { :message => 'has already been blocked' }
  
end
