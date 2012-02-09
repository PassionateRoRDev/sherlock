class UserHasCompanyName < ActiveRecord::Migration
  def up
    add_column :users, :company_name, :string
    ActiveRecord::Base.connection.execute('UPDATE users SET company_name = "Your Company Name"')
  end

  def down
    remove_column :users, :company_name
  end
end
