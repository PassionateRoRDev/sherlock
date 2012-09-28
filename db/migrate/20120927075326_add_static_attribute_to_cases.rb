class AddStaticAttributeToCases < ActiveRecord::Migration
  def change
    add_column :cases, :is_static, :boolean, :default => false
  end
end
