class SpellcheckController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  skip_before_filter :verify_authenticity_token, :only => :lookup
  
  def lookup
    
    logger.debug('Lookup params:')
    logger.debug(params)
    
    result = []
    
    s = SpellCheck.new
    
    words = params[:params][0]
    case params[:method].to_sym
    when :checkWords      
      result = s.check_words(words)      
    when :getSuggestions
      result = s.suggestions(word)      
    end
        
    response = {
      :id     => params[:id], 
      :result => result,
      :error  => nil
    }
    
    logger.debug(response)
    
    render :json => response
    
  end
  
end
