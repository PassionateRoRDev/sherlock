class BlocksController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_pi!
    
  before_filter :resolve_block
  before_filter :verify_case_author!
  
  def destroy
    
    c = @block.case  
    @block.destroy
    @blocks_count = c.blocks.count
    respond_to do |format|
      format.html { redirect_to(c, :notice => 'The block was successfully deleted') }
      format.js
    end
    
  end
  
  private
  
  def resolve_block
    @block = current_company.blocks.find_by_id(params[:id]) || 
      redirect_to(cases_path)
  end
  
  def verify_case_author!    
    is_author = (@block.case.author == current_company)
    redirect_to @block.case unless is_author    
  end
  
end
