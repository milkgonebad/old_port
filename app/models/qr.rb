class Qr < ActiveRecord::Base
  
  scope :available, -> { where used: nil }
  
end
