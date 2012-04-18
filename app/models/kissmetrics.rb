class Kissmetrics
  def self.init_and_identify(identity)
    KM.init("536e73d0a9cf1146c1718b6c44e7d555855e8493")
    KM.identify(identity)
  end
end
