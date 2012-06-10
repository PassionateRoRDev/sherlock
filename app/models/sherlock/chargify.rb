require 'digest/md5'

class Sherlock::Chargify

  HEADERS = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  AUTH_PASSWORD = 'x'
  
  def initialize
    @response_code = 0
    @errors = []
  end
  
  def response_code
    @response_code
  end
  
  def errors
    @errors    
  end
  
  def calculate_webhook_signature(raw_post)    
    Digest::MD5.hexdigest(config['shared_site_key'] + raw_post)    
  end
  
  def config
    APP_CONFIG['chargify']
  end
  
  def base_url
    'https://' + config['subdomain'] + '.chargify.com/'
  end
      
  def cancel(subscription_id)
    Chargify::Subscription.find(subscription_id).cancel          
  end
  
  def charge(subscription_id, amount, memo)  
    path = "subscriptions/#{subscription_id}/charges.json"
    body = { :charge => { :amount => amount, :memo   => memo } }    
    do_post(path, body)
  end
  
  private
  
  def resolve_errors(response_code, result)
    
    if result.status >= 400 && result.status <= 599
      body = result.body.strip      
      if body.present?
        JSON.parse(result.body)['errors']
      else
        [ 'Generic error (' + response_code.to_s + ')' ]
      end
    else
      []
    end
    
  end
  
  def process_result(result)
    @response_code = result.status    
    @errors = resolve_errors(@response_code, result)
  end
    
  def do_post(path, body)    
    uri = base_url + path    
    result = setup_client.post(uri, :header => HEADERS, :body => body.to_json)    
    process_result result
  end  
  
  def setup_client
    client = HTTPClient.new
    client.set_auth(nil, config['api_key'], AUTH_PASSWORD)    
    client
  end

end
