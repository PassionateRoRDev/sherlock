class AddReportSentAtToCapturedEmails < ActiveRecord::Migration
  def change
    add_column :captured_emails, :report_sent_at, :datetime
  end
end
