module AuthHelper
  
  def investigators_only(&block)
    block.call if (current_user && current_user.pi?)
    nil
  end
  
  def case_author_only(kase)
    is_author = (current_user && (kase.author == current_user))
    yield if is_author    
    nil
  end
  
end