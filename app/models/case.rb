class Case < ActiveRecord::Base

  belongs_to :user
  has_many :blocks, :dependent => :destroy
  
  validates :title, :presence => true
  
end
