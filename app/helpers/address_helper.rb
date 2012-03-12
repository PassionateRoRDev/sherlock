module AddressHelper
  
  def states_options    
    [
      ['-- select state --', nil],
      ['California', 'CA'],
      ['Illinois', 'IL'],
      ['New York', 'NY'],
      ['Oregon', 'OR'],
      ['Washington', 'WA'],
    ]
  end
  
  def countries_options
    ['USA', 'Canada']    
  end
  
end
