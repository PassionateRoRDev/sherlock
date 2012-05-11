class Kissmetrics
    
  def self.generate_anonymous_id(request)
    now = Time.now.to_i  
    Digest::MD5.hexdigest(
      (request.referrer || '') + 
      rand(now).to_s + 
      now.to_s + 
      (request.user_agent || '')
    )
  end
  
end
