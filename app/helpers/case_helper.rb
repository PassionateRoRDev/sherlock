module CaseHelper
  
  def date_value(date)    
    date.blank? ? '' : date.strftime('%m/%d/%Y')    
  end
  
  def cases_options(cases)
    cases.map { |c| [ c.title, c.id ] }
  end
    
  def title_alignment_options
    [      
      ['Left', 'left'],
      ['Right', 'right'],
      ['Center', 'center']
    ]
  end
  
  def case_title_style(kase)
    
    case kase.title_alignment.to_s
    when 'right'
      'text-align:right;clear:both;'
    when 'center'
      'text-align:center;clear:both;'
    else
      'clear:both;'
    end
    
  end
  
end
