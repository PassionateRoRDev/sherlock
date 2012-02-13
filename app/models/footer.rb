class Footer < ActiveRecord::Base

  belongs_to :case

  def as_json(options = {})    
    
    result = super(options)
    
    if options[:camelize]
      result.keys.each { |k| result[k.to_s.camelize(:lower)] = result[k] }      
    end
        
    if divider_above
      result[:topDivider] = {
        :color  => divider_color,
        :width  => divider_width,
        :height => divider_size
      }
    end
    if divider_below
      result[:bottomDivider] = {
        :height => 1
      }
    end
    result
  end
  
  def is_link
    self.link.present?
  end
  
  def is_link=(is)    
  end
  
end
