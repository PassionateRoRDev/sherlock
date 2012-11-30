class AddActiveStatusToEmployees < ActiveRecord::Migration
  def change
    add_column :user_employees, :active, :boolean, :null => false, :default => true
  end
end
