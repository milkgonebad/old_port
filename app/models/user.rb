class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :orders
  has_many :tests, :through => :orders
  
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness:  true
  validates :address1, :city, :state, :country, presence: true, unless: Proc.new { |a| a.admin? }
  validates :control_number, numericality: { only_integer: true }, unless: Proc.new { |a| a.admin? }
  
  validates :password, length: { in: 8..128 }, on: :create
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true
  
  scope :customers, -> { where('role is null', active: true).order(:last_name, :first_name) } # note "->" is the same thing as "lamda" - very annoying
  scope :all_customers, -> { where('role is null').order(:last_name, :first_name) }
  scope :administrators, -> { where(role: 1, active: true).order(:last_name, :first_name) }
  scope :all_administrators, -> { where('role is not null').order(:last_name, :first_name) }
  
  ROLES = {:customer => nil, :super_administrator => 0, :administrator => 1}
  
  def admin?
    !role.nil? 
  end
  
  def is_super_admin?
    role == ROLES[:super_administrator]
  end

end
