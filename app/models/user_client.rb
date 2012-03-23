class UserClient < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'
  
end
