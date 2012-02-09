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

  def case
    Case.find self.case_id
  end

  def deliver 
    valid? && find_or_create_guest && set_permissions && deliver_email
  end
   
  def find_or_create_guest 
    @guest ||= User.where(:email => self.email).first || 
         User.invite!(:email => self.email, 
                      :name => self.name, 
                      :skip_invitation => true)
  end

  def set_permissions
    self.case.viewers << self.guest
  end

  def deliver_email
    PostOffice.invitation( self.with_presentation_layer ).deliver
  end

  def guest
    self.find_or_create_guest
  end

  def with_presentation_layer
    if self.guest.invited?
      IntroductoryInvitationPresenter.new( self )
    else
      RepeatInvitationPresenter.new( self )
    end
  end
end

