class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :company_name
 
  has_many :authored_cases, :class_name => 'Case', :foreign_key => 'author_id' 
  has_and_belongs_to_many :viewable_cases, :join_table => 'viewers', :foreign_key => 'viewer_id', :association_foreign_key => 'case_id', :class_name => 'Case'
  has_many :blocks, :through => :authored_cases
  
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks

  def find_case_by_id(case_id)
    authored_cases.find_by_id(case_id) || viewable_cases.find_by_id(case_id)
  end
  
  def cases
    authored_cases + viewable_cases
  end

  def invited?
    ! self.invitation_token.blank?  
  end

  def can_view?( object )
    case object
    when Case
      object.viewers.include?( self ) || object.author == self
    else
      false
    end
  end

  has_one :letterhead
  
end

