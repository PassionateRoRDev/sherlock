class ContactMessage
  
  include ActiveModel::Validations
  include ActiveModel::Conversion        
  
  attr_accessor :first_name, :last_name, :email, :message
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :message, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end  
  
  def deliver
    PostOffice.contact_message(self).deliver
  end
  
end
