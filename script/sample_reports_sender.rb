
url_helpers = Rails.application.routes.url_helpers
s = SampleReport.new
s.link_signup = url_helpers.new_user_registration_url(:host => 'sherlockdocs.com')

CapturedEmail.where(:report_sent_at => nil).each do |record|
  s.email = record.email
  s.deliver
  record.report_sent_at = Time.now
  record.save
end
