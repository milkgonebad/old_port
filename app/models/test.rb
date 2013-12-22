class Test < ActiveRecord::Base
  belongs_to :order
  belongs_to :user # customer user - not so normalized
  #TODO need a belongs_to for admin tester
  
  validates :order, :status, presence: true # tests cannot exist without an order
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, numericality: { less_than_or_equal_to: 50.00 }, allow_blank: true
  
  STATUSES = {not_received: 'NOT_RECEIVED', received: 'RECEIVED', in_progress: 'IN_PROGRESS', complete: 'COMPLETE'}
  SAMPLE_TYPES = ['Flower', 'Concentrate', 'Oil', 'Edible']
  
  after_initialize do |t|
    t.status = STATUSES[:not_received] if t.status.nil?
  end
  
  scope :no_qr_code, -> { where qr_code_number: nil }
  
  has_attached_file :plate,  :default_url => "/images/:style/missing.png",
    styles: {
      thumb: '100x100>',
      square: '200x200>',
      medium: '300x300>'
    }
  
  #FIXME:  These could be metaprogrammed into something smarter but rails 4.1 has that nice enum feature...
  def in_progress?
    status == STATUSES[:in_progress]
  end
  
  def complete?
    status == STATUSES[:complete]
  end
  
  def not_received?
    status == STATUSES[:not_received]
  end
  
  def received?
    status == STATUSES[:received]
  end
  
end
