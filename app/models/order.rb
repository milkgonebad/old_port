class Order < ActiveRecord::Base
  belongs_to :user # customer
  has_many :tests
end
