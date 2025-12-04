class Memo < ApplicationRecord
  belongs_to :schedule
  
  validates :memo, presence: true, length: { maximum: 1000 }
  validates :schedule_id, presence: true
end
