class Case < ActiveRecord::Base

  belongs_to :user
  
  has_many :blocks, :dependent => :destroy
  has_many :html_details, :through => :blocks
  
  validates :title, :presence => true
  
end
