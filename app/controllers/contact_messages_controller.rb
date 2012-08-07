class ContactMessagesController < ApplicationController

  DEFAULT_VALUES = {
    :first_name => 'First Name',
    :last_name  => 'Last Name',
    :email      => 'Email Address',
    :message    => 'Message'
  }
  
  def new
    @title = 'Contact'    
    @contact_message = ContactMessage.new    
    render 'new', :layout => false
  end
  
  def create
    
    message = params[:contact_message]
    DEFAULT_VALUES.each_pair do |key, value|       
      message.delete(key) if message[key] == value      
    end
        
    @contact_message = ContactMessage.new(message)    
    if @contact_message.valid?           
      @contact_message.deliver
      redirect_to new_contact_message_path, 
                  :notice => 'Your message was successfully sent'
    else      
      render 'new', :layout => false
    end
    
  end

end
