class SearchController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index    
    term = params[:term].to_s                    
    render :json => search_cases(term) + search_folders(term)    
  end
  
  private
  
  def search_cases(term)
    current_company.find_cases(term).map { |c| case_to_result(c) }    
  end
  
  def search_folders(term)
    current_company.find_folders(term).map { |f| folder_to_result f }                  
  end
  
  def folder_to_result(f)
    { :type => :folder, :id => f.id, :value => f.title, :label => f.title + ' [F]' }  
  end
  
  def case_to_result(c)
    { :type => :case, :id => c.id, :value => c.title, :label => c.title }    
  end
  
end
