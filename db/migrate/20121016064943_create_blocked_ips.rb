class CreateBlockedIps < ActiveRecord::Migration
  def change
    create_table :blocked_ips do |t|
      t.string :ip, :null => false, :unique => true
      t.timestamps
    end
  end 
end
