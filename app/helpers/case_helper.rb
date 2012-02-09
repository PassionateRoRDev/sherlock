module CaseHelper
  
  def date_value(date)    
    date.blank? ? '' : date.strftime('%m/%d/%Y')    
  end
  
end
