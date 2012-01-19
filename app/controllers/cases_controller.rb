class CasesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def new
    @case = Case.new
  end

end
