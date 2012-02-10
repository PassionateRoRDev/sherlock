class Footer < ActiveRecord::Base

  belongs_to :case

  def as_json(options = {})
    {
      :text       => self.contents,
      :fontSize   => self.font_size,
      :textAlign  => self.text_align
    }    
  end
  
end
