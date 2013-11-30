class Test < ActiveRecord::Base
  belongs_to :order
  belongs_to :admin # admin tester
end
