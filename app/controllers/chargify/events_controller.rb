class Chargify::EventsController < ApplicationController
  
  protect_from_forgery :except => :create
  
  def create
        
    body = request.raw_post
    
    pp "Body is:"
    pp body
    
    pp "Params:"
    pp params
    
    signature = params[:signature].to_s    
    
    #pp "Signature: #{signature}"
    
    c = ::Sherlock::Chargify.new
    calculated = c.calculate_webhook_signature(body)
    
    if signature.present? 
      unless (signature == calculated)
        logger.error("Webhook signature not valid (expected #{calculated})")
      else
        payload = params[:payload]    
        unless payload
          logger.error("Payload is missing!")
        else
          subscription = payload[:subscription]
          unless subscription
            logger.error("Subscription info not present")
          else
            local = ::Subscription.find_by_chargify_id(subscription[:id])
            unless local
              logger.error("Subscription record not found in the database (id=#{subscription[:id]})")
            else              
              local.apply_chargify_event(subscription)
            end
          end
        end
      end
    end

    render :json => { :status => :ok }
    
  end
  
end
    
