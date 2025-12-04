class Card < ApplicationRecord
  belongs_to :lane
  # 優先度をenumで定義すると便利です
  enum priority: { low: 1, medium: 2, high: 3 }
end
