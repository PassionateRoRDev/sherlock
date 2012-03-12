class SpellcheckController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => :lookup
  
  def lookup
    
    logger.debug('Lookup params:')
    logger.debug(params)
    
    result = []
    
    s = SpellCheck.new
    
    case params[:method].to_sym
    when :checkWords      
      words = params[:params][1]
      result = s.check_words(words)      
    when :getSuggestions
      word = params[:params][1]
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
