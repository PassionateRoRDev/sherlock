module AuthHelper
  
  def investigators_only(&block)
    block.call if (current_user && current_user.pi?)
    nil
  end
  
end