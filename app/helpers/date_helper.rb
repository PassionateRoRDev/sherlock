module DateHelper
  
  def format_date(t)
    t.in_time_zone('EST').strftime('%m/%d/%Y %H:%M %Z')
  end
  
end