class Letterhead < ActiveRecord::Base
  
  belongs_to :user
  
  has_one :logo
      
  accepts_nested_attributes_for :logo
  
  after_save :invalidate_reports
  
  def is_link=(is)    
  end
  
  def is_link
    self.link.to_s != ''
  end
  
  def alignment
    'center'
  end

  def lines_count
    self.contents.to_s.lines.count
  end
  
  def as_json(options = {})
    
    Rails::logger.debug("Letterhead as json - options")
    Rails::logger.debug(options)

    result = super(options)
    
    Rails::logger.debug("Letterhead - result logo:::")
    Rails::logger.debug(result['logo'])
    Rails::logger.debug(result[:logo])
    
    result[:text] = result['contents']
    
    if options[:camelize]      
      result.keys.each { |k| result[k.to_s.camelize(:lower)] = result[k] }      
    end
    
    if divider_above
      result[:divider] = {
        :color  => divider_color,
        :width  => divider_width,
        :height => divider_size
      }
    end
    
    if logo
      dims = logo.dims            
      result['logo'][:width]  = dims ? dims[0] : 0
      result['logo'][:height] = dims ? dims[1] : 0      
      result['logo'][:align] = logo_alignment              
      result['logo'][:path]  = logo.main_file_asset.full_filepath      
    end
    
    #Rails::logger.debug('RESULT:')
    #Rails::logger.debug(result)
    
    result
  end
  
  private
  
  def invalidate_reports
    Report.invalidate_for_user self.user_id
  end
  
end
