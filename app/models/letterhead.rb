class Letterhead < ActiveRecord::Base
  
  belongs_to :user
  
  before_destroy :delete_logo
  
  include FileAsset  
  
  def self.store_logo(user, upload_info)    
    FileAsset::store_for_type(user, upload_info, 'logos')            
  end
  
  def file_type
    'logos'
  end
  
  def is_link=(is)    
  end
  
  def is_link
    self.link.to_s != ''
  end
  
  def path
    logo_path
  end
  
  # Overrides author_id from FileAsset
  def author_id
    self.user.id
  end
  
  def delete_logo
    delete_file_for_type(file_type)  
  end

  def as_json(options = {})

    result = super(options)
    
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
    
    if logo_path.present?      
      dims = File.exists?(full_filepath) ? Dimensions.dimensions(full_filepath) : nil
      result[:logo] = {
        :align  => logo_alignment,
        :path   => logo_path,
        :width  => dims ? dims[0] : 0,
        :height => dims ? dims[1] : 1        
      }
    end
    
    result
  end
  
end
