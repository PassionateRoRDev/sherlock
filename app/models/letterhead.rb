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
    self.link.present?
  end
  
  def path
    logo_path
  end
  
  # Overrides user_id from FileAsset
  def user_id
    self.user.id
  end
  
  def delete_logo
    delete_file_for_type(file_type)  
  end

  def as_json(options = {})

    should_camelize = options[:camelize]
    
    options = {
      :exclude => [:id, :updated_at, :created_at]
    }
    
    result = super(options)
    
    if should_camelize
      Rails::logger.debug("TRANSFORMING!")
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
      result[:logo] = {
        :alignment  => result[:logo_alignment],
        :path       => result[:logo_path]
      }
    end
    
    result
  end
  
end
