class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :email, presence: true
  
  ROLES = [:customer => nil, :super_admin => 0, :admin => 1]
  
  def admin?
    !role.nil? 
  end
  
end
