module TextHelper
  
  def print_or(s, default = '-')
    s.to_s.present? ? s : default
  end
  
end