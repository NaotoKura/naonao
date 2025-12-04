class Post < ApplicationRecord
  belongs_to :user, -> { with_discarded }
  has_many :likes, dependent: :delete_all

  include Discard::Model
  default_scope -> { kept }

  validates :user_id, {presence: true}
  validates :content, {
    presence: {message: "は１文字以上入力してください。"},
    # length:{maximum: 140},
    # format: {with: /[a-zA-Z]+/}
  }
  validates :user_id, {presence: true}

  # validate :check_symbol

  # def check_symbol
  #   if [".", "/", "@", "．", "／", "＠"].any? {|str| content.include?(str)}
  #     #trueの時にエラー文
  #     errors.add(:content, "に使用できない文字が含まれています。")
  #   end
  # end
  # .@/が投稿内容に含まれていたら弾く
  # 最低１文字以上の英字を含む
  # バリデーションとは、データベースに保存する前に保存する内容を検証する機能
  # presence: trueで空でないこと、length:{maximum: 140}で文字の長さが140文字以下
end
