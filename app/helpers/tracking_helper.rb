module TrackingHelper
    
  def kissmetrics_track(&block)
    block.call if Rails.env == 'production'  
    nil
  end
  
end