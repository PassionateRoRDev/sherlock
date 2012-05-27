class Setting < ActiveRecord::Base

  def self.has_non_cc_trial?    
    Setting.first && Setting.first.non_cc_trial.to_i > 0    
  end
  
end
