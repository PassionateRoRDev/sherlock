class PageBreaksController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  before_filter :resolve_case
  
  respond_to :html, :json, :except => :update

  def create
        
    @page_break = BlockTypes::PageBreak.new(params[:page_break])
    block = Block.new(:case => @case)    
    
    @insert_before_id = params[:insert_before_id].to_i
    block.insert_before_id = @insert_before_id
    @page_break.block = block    
    
    respond_to do |format|
      if (@page_break.save)        
        @block = @page_break.block
        logger.debug("Page Break saved")
        format.html { redirect_to(@case, :notice => 'New Page Break has been created') }
        format.js
      else  
        logger.debug("Page Break not saved")
        format.html { render :action => 'new' }
      end
    end        
    
  end
    
  def update
    @page_break = @case.page_breaks.find_by_id(params[:id])    
    redirect_to cases_path unless @page_break
    
    respond_to do |format|
      if @page_break.update_attributes(params[:page_break])
        @block = @page_break.block
        format.html { redirect_to(@case, :notice => 'The block has been successfully updated') }
        format.js
      else
        format.html { render :action => 'edit' }
      end
    end
    
  end
  
  private
  
  def resolve_case
    resolve_case_using_param(:case_id)    
  end

end
