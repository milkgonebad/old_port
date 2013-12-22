class Test < ActiveRecord::Base
  belongs_to :order
  belongs_to :user # customer user - not so normalized
  #TODO need a belongs_to for admin tester
  
  has_attached_file :plate,  :default_url => "/images/:style/missing.png",
    styles: {
      thumb: '100x100>',
      square: '200x200>',
      medium: '300x300>'
    }
  
  validates :order, :status, :user, presence: true # tests cannot exist without an order
  validates :qr_code_number, presence: true, if: :received?
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, numericality: { less_than_or_equal_to: 50.00 }, allow_blank: true
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, :strain, :sample_type, presence: true, if: :complete? 
  
  #FIXME:  the content type and size validations are not working 
  # see https://github.com/thoughtbot/paperclip/issues/1292
  validates :plate, :attachment_presence => true, if: :complete?
  # validates_attachment :plate, :presence => true, :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
    # :size => { :in => 0..10.kilobytes }, if: :complete?

  STATUSES = {not_received: 'NOT_RECEIVED', received: 'RECEIVED', in_progress: 'IN_PROGRESS', complete: 'COMPLETE'}
  SAMPLE_TYPES = ['Flower', 'Concentrate', 'Oil', 'Edible']
  
  after_initialize do |t|
    t.status = STATUSES[:not_received] if t.status.nil?
  end
  
  scope :no_qr_code, -> { where qr_code_number: nil }
  
  after_save :update_status_timestamps
  
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
  
  def next_status
    case status
      when STATUSES[:not_received]
        STATUSES[:received]
      when STATUSES[:received]
        STATUSES[:in_progress]
      when STATUSES[:in_progress]
        STATUSES[:complete]
      else
        status # this shouldn't happen
    end
  end
  
  def update_status_timestamps
    puts "###### updating timestamps!!!"
    if valid?
      case status
        when STATUSES[:received]
          update_attribute(:received_at, Time.now) if received_at.nil?
        when STATUSES[:in_progress]
          update_attribute(:in_progress_at, Time.now) if in_progress_at.nil?
        when STATUSES[:complete]
          update_attribute(:completed_at, Time.now) if completed_at.nil?
      end
    end
  end
  
end
