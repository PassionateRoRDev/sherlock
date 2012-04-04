module BlockDetail
  
  def invalidate_report
    Report.invalidate_for_case self.block.case_id
  end
  
end
