class UserAddress < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :address, :state, :city, :country, :zip
  
end
