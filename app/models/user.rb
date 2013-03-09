class User < ActiveRecord::Base
  
  BETA_PERIOD = false
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :company_name,
                  :first_name, :last_name,                  
                  :user_address_attributes,
                  :skip_invitation
 
  attr_accessor :password_plain, :is_new
  
  has_many :authored_cases, :class_name => 'Case', :foreign_key => 'author_id' 
  has_and_belongs_to_many :viewable_cases, :join_table => 'viewers', :foreign_key => 'viewer_id', :association_foreign_key => 'case_id', :class_name => 'Case'
        
  has_many :sent_emails
  
  has_many :user_clients
  has_many :clients, :through => :user_clients
      
  has_many :user_employees
  has_many :employees, :through => :user_employees    
  
  has_one :employee_info, :foreign_key => 'employee_id', :class_name => 'UserEmployee'
  
  accepts_nested_attributes_for :employee_info
  
  has_and_belongs_to_many :employers, 
                          :join_table => 'user_employees', 
                          :foreign_key => 'employee_id', 
                          :association_foreign_key => 'user_id', 
                          :class_name => 'User'
    
  has_many :folders
  
  has_many :purchases  
  has_many :subscriptions
    
  has_many :text_snippets
  
  has_many :blocks, :through => :authored_cases
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks
  
  has_one :letterhead, :dependent => :destroy
  has_many :logos, :dependent => :destroy
  
  has_many :notes, :through => :authored_cases
  
  has_one :user_address, :dependent => :destroy

  accepts_nested_attributes_for :user_address
  
  after_create :setup_free_plan_for_pi
  
  RANDOM_PASSWORD_LENGTH = 10
  
  def self.investigators
    joins(:subscriptions).group('users.id')
  end
  
  def self.clients
    joins('LEFT JOIN subscriptions ON subscriptions.user_id = users.id')
    .where(:admin => 0)
    .group('users.id')
    .having('count(subscriptions.id) = 0')    
  end
    
  def self.create_from_chargify_subscription(subscription)      
      
      customer = subscription.customer
      password = generate_random_password RANDOM_PASSWORD_LENGTH
            
      exists = User.find_by_email(customer.email)
      
      existing_subscription = exists ? exists.current_subscription : nil
    
      user = User.find_or_create_by_email(
        :email                  => customer.email,
        :first_name             => customer.first_name,
        :last_name              => customer.last_name,
        :company_name           => customer.organization,
        :password               => password, 
        :password_confirmation  => password
      )
            
      unless user.user_address
        
        cc = subscription.credit_card
      
        user.user_address = UserAddress.new(          
          :address  => (cc.billing_address.to_s + ' ' + cc.billing_address_2.to_s).strip,
          :city     => cc.billing_city,
          :state    => cc.billing_state,
          :country  => cc.billing_country,
          :zip      => cc.billing_zip,
          :phone    => customer.phone          
        )
      end
      
      user.subscriptions << ::Subscription.create_from_chargify(user, subscription)
      
      if exists
        Rails::logger.debug('The user already existed')
        existing_subscription.cancel if existing_subscription
      else
        user.is_new = true
        user.password_plain = password
      end
      
      return user
      
  end
    
  def setup_free_trial    
    self.subscriptions << ::Subscription.create_free_trial(self)
  end
  
  def plans_to_upgrade    
    s = self.current_subscription
    (s && !s.is_expired?) ? s.plans_to_upgrade : SubscriptionPlan.all_but_free
  end
    
  def company
    employer.present? ? employer : self
  end
  
  def current_subscription
    self.subscriptions.last
  end
  
  def current_plan
    current_subscription ? current_subscription.subscription_plan : nil
  end
  
  def current_subscription_name
    current_subscription ? current_subscription.product_handle : ''
  end

  def current_subscription_ends
    current_subscription ? current_subscription.period_ends_at : nil
  end
  
  def base_cases_for_find
    pi? ? authored_cases : viewable_cases                                   
  end
  
  def find_cases(term)     
    base_cases_for_find.where('title LIKE ?', "%#{term}%")
  end
  
  def find_folders(term)
    pi? ? folders.where('title LIKE ?', "%#{term}%") : []
  end
  
  def header_on_all_pages
    letterhead.nil? || letterhead.all_pages    
  end
  
  def employer
    employers.first
  end
  
  def case_created(c)
    
    #
    # Static cases do not count really
    #
    unless c.is_static        
      if can_create_from_subscription?
        current_subscription.case_created(c)
      else
        current_subscription.extra_case_created(c) if current_subscription
        use_up_purchase(c)
      end        
    end
    
  end
  
  def use_up_purchase(c)    
    purchase = oldest_unused_purchase
    purchase.use_up_for_case(c) if purchase      
  end
  
  def unused_purchases
    self.purchases.where(:label => :one_time_report, :used_at => nil)
  end
  
  def oldest_unused_purchase
    unused_purchases.first
  end
  
  def has_unused_purchases?
    not oldest_unused_purchase.nil?
  end
  
  def can_create_case?
    BETA_PERIOD || can_create_from_subscription? || has_unused_purchases?
  end
  
  def can_create_from_subscription?
    s = current_subscription
    s && s.is_active? && (s.cases_count < s.cases_max) && (s.period_ends_at > Time.now)
  end
  
  def send_welcome_message
    presenter = SignupPresenter.new(self)
    PostOffice.welcome(presenter).deliver
  end
  
  def find_case_by_id(case_id)
    authored_cases.find_by_id(case_id) || viewable_cases.find_by_id(case_id)
  end
  
  def init_address
    self.user_address = UserAddress.new(
      :user     => self,
      :country  => "USA"
    )
  end
  
  def add_client(client)
    self.clients << client unless self.clients.include?(client)
  end
  
  def phone
    self.user_address ? self.user_address.phone : nil
  end
  
  def full_name
    result = (self.first_name.to_s + ' ' + self.last_name.to_s).gsub(/\s\s+/, '').strip
    result.empty? ? self.email : result
  end
  
  def cases_usage
    cases.empty? ? 0 : cases.map(&:usage).reduce(:+)
  end
  
  def logos_usage
    logos.empty? ? 0 : logos.map(&:usage).reduce(:+)    
  end
  
  def space_usage    
    cases_usage + logos_usage
  end
  
  def self.generate_random_password(len)
    (0...len).map{ ('a'..'z').to_a[rand(26)] }.join
  end
    
  def cases
    (authored_cases + viewable_cases).uniq    
  end
      
  def invited?
    ! self.invitation_token.blank?  
  end
  
  def billing_zip
    from_address :zip    
  end
  
  def billing_city
    from_address :city
  end
  
  def phone
    from_address :phone
  end
  
  #
  # PI's are uses who haven't been invited OR those that have subscriptions
  # linked
  # 
  # Employees have also pi? set to true
  #
  def pi?        
    (invitation_accepted_at.blank? && (!invited?)) || has_subscriptions?    
  end
  
  def employee?
    employer.present?
  end
  
  def has_subscriptions?
    !self.subscriptions.empty?
  end

  def can_view?( object )
    case object
    when Case
      object.viewers.include?( self ) || object.author == self
    else
      false
    end
  end 
  
  def active_for_authentication? 
    if employee?
      employee_info.active && super
    else
      super
    end
  end 
  
  private
  
  def from_address(name)
    self.user_address ? self.user_address.send(name) : ''
  end
  
  def setup_free_plan_for_pi
    Rails::logger.debug 'Setup free plan for PI?'
    setup_free_trial if pi? && (!employee?) && Setting.has_non_cc_trial? && subscriptions.empty?      
  end
      
  
end

