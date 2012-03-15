ActionMailer::Base.smtp_settings = {
  :address  => 'relay.cloudsmtp.com',
  :port => 587,
  :user_name => 'jinnasoft',  
  :password => 'sherl0ckdocs40!',  
  :authentication       => 'LOGIN'
  # :enable_starttls_auto => true
  
  #:openssl_verify_mode => 'none'
}
