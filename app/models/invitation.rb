class Invitation < Valuable
  extend ActiveModel::Naming
  include ActiveModel::Conversion # required for forms
  include ActiveModel::Validations

  has_value :email
  has_value :name
  has_value :message
  has_value :case_id

  validates :email, :email => true
  validates_presence_of :email, :name, :message, :case_id

  def to_model
    self
  end

  def persisted?() false end
  def new_record?() true end
  def destroyed?()  true end

  def target
    "#{self.name} <#{self.email}>"
  end
 
  def case
    Case.find self.case_id
  end

  def deliver 
    self.valid? && !!PostOffice.report( self ).deliver.inspect
  end
    
#  def find_or_create_user
#    User.where(:email => self.email).first || User.invite!(:email => self.email)
#  end
end

