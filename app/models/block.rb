class Block < ActiveRecord::Base
  
  belongs_to :case
  
  has_one :html_detail, :dependent => :destroy    
  has_one :picture, :dependent => :destroy
  has_one :video, :dependent => :destroy
  has_one :data_log_detail, :dependent => :destroy
  has_one :page_break, :class_name => 'BlockTypes::PageBreak',  
          :dependent => :destroy  
  
  has_one :witness_statement, :class_name => 'BlockTypes::WitnessStatement',  
          :dependent => :destroy
  
  attr_accessor :insert_before_id
  
  before_create :initialize_weight
  after_create :adjust_weight_after_insert
  
  before_destroy :adjust_weights
  before_destroy :invalidate_report
  
  default_scope :order => 'weight'
  
  def scaling
    if self.picture
      self.picture.scaling
    elsif self.video
      self.video.scaling
    end    
  end
  
  def alignment
    if self.picture
      self.picture.alignment
    elsif self.video
      self.video.alignment
    end
  end
  
  def has_meta?
    has_scaling? || has_alignment?
  end
  
  def has_scaling?
    scaling.to_s.present?
  end
  
  def has_alignment?
    alignment.to_s.present?
  end
  
  # Layout strategy - used during the Preview and PDF:
  # 
  # if element is LEFT-floated, 
  # - if it's preceded by RIGHT float, apply BR after it
  # - else render BR.clear before it
  #
  # - if element is RIGHT-floated
  # - if it's preceded by LEFT floated element, apply BR.clear AFTER it
  # - else apply BR.clear before it
  #  
  def clear
    prev_block = prev
    case alignment
    when 'left'
      (prev_block && prev_block.alignment == 'right') ? :after : :before
    when 'right'
      (prev_block && prev_block.alignment == 'left') ? :after : :before
    else
      nil
    end    
  end
    
  def floated?
    alignment == 'left' || alignment == 'right'
  end
  
  def usage
    if self.picture    
      self.picture.usage 
    elsif self.video
      self.video.usage
    else
      0
    end
  end
  
  def block_type
    if self.html_detail
      'text'
    elsif self.data_log_detail
      'data-log'
    elsif self.witness_statement
      'witness-statement'
    elsif self.picture
      'picture'
    elsif self.video
      'video'
    end
  end
  
  def title
    result = 'Block'
    if self.html_detail
      result = 'Text Block'
    end
    if self.data_log_detail
      result = 'Data Log'
    end
    if self.witness_statement
      result = 'Witness Statement'
    end
    if self.picture
      result = 'Picture Block'
    end
    if self.video
      result = 'Video Block'
    end
    if self.page_break
      result = "Page Break Block"
    end
    result
    
  end
  
  def prev
    self.case.blocks.where(:weight => self.weight - 1).first
  end
  
  def prev_id
    prev.present? ? prev.id : 0
  end
    
  def next_sibling
    self.case.blocks.where(:weight => self.weight + 1).first
  end
  
  def next_id
    next_sibling.present? ? next_sibling.id : 0
  end
  
  def as_json(options = {})    
    
    #Rails::logger.debug("as_json: options")
    #Rails::logger.debug(options)
    
    include = []
    except = [:created_at, :updated_at, :id, :case_id]    
    result = super(:include => include, :except => except)
    
    options = {
      :for_pdf => options ? options[:for_pdf] : false,
      :except => [:id, :block_id, :updated_at, :created_at]
    }        
    
    if self.data_log_detail
      result['dataLogDetail'] = self.data_log_detail.as_json(options)
    end
    if self.witness_statement
      result['witnessStatement'] = self.witness_statement.as_json(options)
    end    
    if self.html_detail 
      result['htmlDetail'] = self.html_detail.as_json(options)
    end
    if self.video
      result['video'] = self.video.as_json(options)            
    end
    if self.picture
      result['picture'] = self.picture.as_json(options)
    end
    if self.page_break
      result['pageBreak'] = self.page_break.as_json(options)
    end
    result
  
  end
  
  private
  
  def initialize_weight
    self.weight = self.case.blocks.maximum('weight').to_i + 1
  end
  
  def adjust_weight_after_insert
    if self.insert_before_id.to_i > 0
      block_before = self.case.blocks.find_by_id(self.insert_before_id)
      if block_before        
        new_weight = block_before.weight
        Block.connection.update(
        "UPDATE blocks SET weight = weight + 1 
         WHERE case_id = #{self.case.id} AND weight >= #{new_weight}")
        self.weight = new_weight
        save
      end
    end
  end
  
  def invalidate_report
    Report.invalidate_for_case self.case_id
  end
  
  def adjust_weights
    case_id = self.case.id.to_i
    weight  = self.weight.to_i
    Block.connection.update(
      "UPDATE blocks SET weight = weight - 1 
       WHERE case_id = #{case_id} AND weight >= #{weight}")
  end
  
end
