module AuthHelper
  
  def investigators_only(&block)
    block.call if (current_company && current_company.pi?)
    nil
  end
  
  def disable_if_employee(&block)
    block.call if (current_user && current_user.pi? && (!current_user.employee?))
    nil
  end
  
  def case_author_only(kase)
    is_author = (current_company && (kase.author == current_company))
    yield if is_author    
    nil
  end
  
end