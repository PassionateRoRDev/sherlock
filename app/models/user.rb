class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :company_name
  
  has_and_belongs_to_many :cases, :join_table => 'viewers', :foreign_key => 'viewer_id', :association_foreign_key => 'case_id'
  has_many :blocks, :through => :cases
  
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks

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

