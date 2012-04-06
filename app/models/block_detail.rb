module BlockDetail
  
  def invalidate_report
    Report.invalidate_for_case self.block.case_id
  end
  
  def case_id
    block ? block.case_id : 0
  end  
  
end
