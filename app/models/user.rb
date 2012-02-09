class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :cases, :dependent => :destroy
  has_many :blocks, :through => :cases
  
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks

  def invited?
    ! self.invitation_token.blank?  
  end
end
