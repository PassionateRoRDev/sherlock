class Storage < ActiveRecord::Base
  
  has_many :pictures;
  has_many :videos
  has_many :logos
  has_many :documents
  
end
