class Task < ApplicationRecord
  belongs_to :user # 担当者
  belongs_to :creator, class_name: 'User'

  # enumでステータスと優先度を管理
  enum status: { not_started: 0, in_progress: 1, processed: 2, completed: 3 }
  # 日本語訳: 未対応, 処理中, 処理済み, 完了
  enum priority: { low: 0, medium: 1, high: 2 }
  # 日本語訳: 低, 中, 高

  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true
  validates :priority, presence: true
  validates :user_id, presence: true
  validates :creator_id, presence: true
  validate :start_date_cannot_be_in_the_past, on: :create
  validate :due_date_cannot_be_before_start_date

  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "は本日以降の日付を選択してください")
    end
  end

  def due_date_cannot_be_before_start_date
    if due_date.present? && start_date.present? && due_date < start_date
      errors.add(:due_date, "は開始日以降の日付を選択してください")
    end
  end
end