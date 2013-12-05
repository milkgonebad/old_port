class Test < ActiveRecord::Base
  belongs_to :order
  belongs_to :user # customer user - not so normalized
  
  #TODO need a belongs_to for admin tester
  
  after_initialize do |t|
    t.status = STATUSES[:not_received]
  end
  
  STATUSES = {not_received: 'NOT_RECEIVED', received: 'RECEIVED', in_progress: 'IN_PROGRESS', complete: 'COMPLETE'}
  
end
