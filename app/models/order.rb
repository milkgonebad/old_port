class Order < ActiveRecord::Base
  belongs_to :user # customer
  has_many :tests
  
  after_create :create_tests
  
  validates :payment_type, :total, :quantity, presence: true
  validates :total, numericality: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  PAYMENT_TYPES = ['Credit Card', 'Cash', 'PayPal', 'Other']

  def set_defaults
    self.quantity = 1
    self.total = 50
  end

  def creator
    admin_id.nil? ? nil : User.find(admin_id).email
  end

  protected
  
  def create_tests
    self.quantity.times { self.tests.create(:user => self.user) }
    logger.debug "I would create a test here this many times:  " << quantity.to_s
  end
  
end
