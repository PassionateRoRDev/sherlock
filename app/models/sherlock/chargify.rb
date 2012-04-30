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
  
  def config
    APP_CONFIG['chargify']
  end
  
  def base_url
    'https://' + config['subdomain'] + '.chargify.com/'
  end
      
  def charge(subscription_id, amount, memo)
  
    client = HTTPClient.new
    client.set_auth(nil, config['api_key'], AUTH_PASSWORD)    
    uri = base_url + "subscriptions/#{subscription_id}/charges.json"
    
    body = {
      :charge => {
        :amount => amount,
        :memo   => memo
      }
    }
    
    result = client.post(uri, :header => HEADERS, :body => body.to_json)    
    @response_code = result.status
        
    if result.status >= 400 && result.status <= 599
      body = result.body.strip      
      if body.present?
        @errors = JSON.parse(result.body)['errors']
      else
        @errors = [ 'Generic error (' + @response_code.to_s + ')' ]
      end
    end
    
  end

end