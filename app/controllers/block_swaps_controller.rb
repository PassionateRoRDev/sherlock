class BlockSwapsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  
  before_filter :resolve_blocks
    
  def create    
    @block1.case.swap_blocks @block1, @block2    
  end
  
  private
  
  def resolve_blocks
    
    @block1 = current_company.blocks.find_by_id(params[:block1_id])
    @block2 = current_company.blocks.find_by_id(params[:block2_id])
              
    unless @block1 && @block2
      redirect_to(cases_path) 
    else
      redirect_to(cases_path) unless @block1.case == @block2.case
    end
    
  end

end
