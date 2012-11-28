class UserEmployee < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :employee, :class_name => 'User', :foreign_key => 'employee_id'
  
end