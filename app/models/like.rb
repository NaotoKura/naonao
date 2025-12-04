class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, {presence: true}
  validates :post_id, {presence: true}

  class << self
    def count_like_datas(current_user)
      {
        total_likes: count_likes(current_user),
        total_liked: count_liked(current_user),
        total_liked_today: count_today_liked(current_user),
        total_liked_week: count_week_liked(current_user),
        most_likes_count_user: most_liked_user_name(current_user)
      }
    end

    # いいねした数を取得する
    def count_likes(current_user)
      joins(:post).where(user_id: current_user.id).where.not(post_id: current_user.posts).length
    end

    # いいねされた数を取得する
    def count_liked(current_user)
      where.not(user_id: current_user.id).where(post_id: current_user.posts).length
    end

    # 今日のいいね数を取得する
    def count_today_liked(current_user)
      where.not(user_id: current_user.id).where(post_id: current_user.posts)
      .where("created_at >= ?", Date.today.midnight)
      .length
    end

    # 一週間以内のいいね数を取得する
    def count_week_liked(current_user)
      start_week = Date.today.beginning_of_week.midnight
      end_week = Time.now.end_of_week
      where.not(user_id: current_user.id).where(post_id: current_user.posts)
      .where(created_at: start_week .. end_week)
      .length
    end

    # 最もいいねしているユーザー名を取得する。
    def most_liked_user_name(current_user)
      likes = where.not(user_id: current_user.id).where(post_id: current_user.posts)
      likes_count = likes.group(:user_id).order("count_all desc").count.to_a
      return nil if likes_count.blank?

      likes_count = likes_count.map {
        |like| like[0] if likes_count[0][1] == like[1]
      }.reject(&:blank?)

      likes = likes.where(user_id: likes_count).order(created_at: :desc)
      User.find(likes.first.user_id).name
    end

    # # 自身がいいねした投稿を取得する
    # def user_like_posts(current_user, post_ids)
    #   where(user_id: current_user.id).where.not(post_id: post_ids)
    # end
  end
end
