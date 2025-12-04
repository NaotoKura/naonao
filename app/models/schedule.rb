class Schedule < ApplicationRecord
  belongs_to :user, -> { with_discarded }
  has_one :memo, dependent: :destroy

  scope :search_schedule, -> date {
    where(date: date) if date.present?
  }

  scope :order_by_asc, -> {
    order(start_time: :asc)
  }
end
