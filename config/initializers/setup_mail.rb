ActionMailer::Base.smtp_settings = {
  :address  => 'smtp.sendgrid.net',
  :port => 587,
  :user_name => 'Jinnasoft',  
  :password => 'Sherl0ckdocs!',  
  :authentication => 'LOGIN'
  # :enable_starttls_auto => true
  
  #:openssl_verify_mode => 'none'
}
