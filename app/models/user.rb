class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :email, :first_name, :last_name, presence: true
  validates :address1, :city, :state, :country, presence: true, unless: Proc.new { |a| a.admin? }
  
  scope :customers, -> { where('role is null', active: true) } # note "->" is the same thing as "lamda" - very annoying
  scope :all_customers, -> { where('role is null') }
  scope :administrators, -> { where(role: 1, active: true) }
  scope :all_administrators, -> { where('role is not null') }
  
  ROLES = {:customer => nil, :super_administrator => 0, :admininstrator => 1}
  
  def admin?
    !role.nil? 
  end
  
end
