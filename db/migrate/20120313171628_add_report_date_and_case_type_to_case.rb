class AddReportDateAndCaseTypeToCase < ActiveRecord::Migration
  def change
    add_column :cases, :report_date, :date
    add_column :cases, :case_type, :string
  end
end
