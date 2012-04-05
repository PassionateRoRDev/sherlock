class Folder < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :cases

  before_destroy :move_cases_to_toplevel
  
  attr_accessible :title
  
  private
  
  def move_cases_to_toplevel    
    self.cases.each { |c| c.move_toplevel }          
  end
  
end
