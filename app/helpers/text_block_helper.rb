module TextBlockHelper

  #
  # If the text block follows 2 blocks each having an alignment, apply clear
  # to itself
  # 
  # TODO: we need to re-think this rule, it's not always good
  #
  def text_block_dynamic_style(text_block)
    
    result = ''
    
    own_block = text_block.block
    prev_block = own_block.prev
    prev_prev_block = prev_block ? prev_block.prev : nil
    if (prev_block && prev_prev_block)
      #result = 'clear:both;' if prev_block.alignment && prev_prev_block.alignment 
      #result = ''
    end        
    result    
  end
  
end