class Event < ActiveRecord::Base
  
  after_initialize :init_timestamp    
  
  def finish
    self.finished_at = Time.now.to_i
    self.duration = self.finished_at - self.started_at
    save
  end  
  
  private
  
  def init_timestamp
    self.started_at ||= Time.now.to_i    
  end
  
end
