class CapturedEmailsController < ApplicationController
  
  def create
    
    @email = CapturedEmail.new(params[:captured_email])
    @email.ip = request.remote_ip

    respond_to do |format|
      success = @email.save 
      unless success      
        exists = CapturedEmail.find_by_email(@email.email)                  
        if exists
          # schedule the report to be resent
          exists.report_sent_at = nil
          exists.save
          success = true
        end
      end
      
      if success
        
#        s = SampleReport.new
#        s.link_signup = new_user_registration_url
#        s.email = @email.email
#        s.deliver
        
        format.html { redirect_to(@email, :notice => 'Email was successfully created.') }
        format.xml  { render :xml => @email, :status => :created, :location => @email }
        format.js
      else
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
        format.js { render 'create_error' }
      end
      
    end

  end
  
end
