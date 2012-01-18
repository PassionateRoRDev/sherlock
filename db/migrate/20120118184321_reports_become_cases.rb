class ReportsBecomeCases < ActiveRecord::Migration
  def up
    rename_table :reports, :cases

    add_column :cases, :number, :string
    add_column :cases, :client_name, :string

    add_column :cases, :opened_on, :date
    add_column :cases, :closed_on, :date
  end

  def down
    remove_column :cases, :number
    remove_column :cases, :client_name
    remove_column :cases, :closed_on
    remove_column :cases, :opened_on

    rename_table :cases, :reports
  end
end
