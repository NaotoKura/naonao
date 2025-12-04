class Board < ApplicationRecord
  belongs_to :user
  has_many :lanes, -> { order(position: :asc) }, dependent: :destroy
end
