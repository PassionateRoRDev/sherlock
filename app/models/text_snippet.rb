class TextSnippet < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :body, :title
  
  validates :title, :presence => true
  validates :body, :presence => true
  
  default_scope :order => 'title'
  
end
