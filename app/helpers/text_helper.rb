module TextHelper
  
  def print_or(s, default = '-')
    s.to_s.present? ? s : default
  end
  
  def print_date_or(s, default = '-')    
    s.to_s.present? ? print_formatted_date(s) : default    
  end
  
  def print_formatted_date(s)
    s.in_time_zone('Eastern Time (US & Canada)').to_formatted_s(:date_time)
  end
  
end