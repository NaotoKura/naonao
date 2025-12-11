class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_current_user, {only: [:edit, :update]}
  before_action :user_info, {only: [:show, :edit, :update, :likes, :discard]}


  def index
    # @users = User.all.search(search_items)
    @users = User.search(search_items).left_joins(:prefecture)
                .select('users.*, prefectures.name AS prefecture_name')
    @prefectures = Prefecture.all
  end

  def show
    render_404 if @user.blank?
    # @user = User.find params[:id]（変更）
    # @total_likes = Like.count_likes(@user)
    # @total_liked = Like.count_liked(@user)
    # @total_liked_today = Like.count_today_liked(@user)
    # @total_liked_week = Like.count_week_liked(@user)
    # @most_likes_count_user = Like.most_liked_user_name(@user)
    @like_datas = Like.count_like_datas(@user)
    # @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
    @posts = Post.order(created_at: :desc)
                  .joins(:user)
                  .select('posts.*, users.image_name, users.name AS user_name')
                  .where(user_id: @user.id)
                  .page(params[:page])
                  .per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      image_name: "default.jpg"
    )
    @user.password_confirmation = params[:password_confirmation]

    # 新規登録時、ユーザー詳細情報を空で登録する。
    @user.build_user_detail

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      # Turbo対応：renderではなくredirect_toを使用
      # エラーメッセージと入力値をflashに保存
      flash[:alert] = @user.errors.full_messages.join(", ")
      flash[:user_params] = { name: params[:name], email: params[:email] }
      redirect_to("/signup")
    end
  end

  def edit
    # @user = User.find params[:id]（変更）
    @prefectures = Prefecture.all
  end

  def update
    # @user = User.find params[:id]（変更）
    if @user.update(user_params) && @user.user_detail.update(detail_params)
      if params[:image].present?
        image = params[:image]
        # binwriteメソッドでファイルを開き、readメソッドで、画像データを読み込む
        File.binwrite("public/user_images/#{@user.id}.jpg", image.read)
      end
      flash[:notice] = "ユーザー情報を編集しました"
      return redirect_to("/users/#{@user.id}")
    end
    @prefectures = Prefecture.all
    render("users/edit")
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user.blank?
      @user = undiscard
      flash[:notice] = "アカウントを復元し、ログインしました" if @user.present?
    end

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました" if flash[:notice].blank?
      redirect_to("/posts/index")
    else
      # Turbo対応：renderではなくredirect_toを使用
      flash[:alert] = "メールアドレスまたはパスワードが間違っています"
      redirect_to("/login")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。お疲れ様でした！"
    redirect_to("/login")
  end


  # 退会したユーザーの投稿も10日間表示する。
  def likes
    # @user = User.find params[:id]（変更）
    # @total_likes = Like.count_likes(@user)
    # @total_liked = Like.count_liked(@user)
    # @total_liked_today = Like.count_today_liked(@user)
    # @total_liked_week = Like.count_week_liked(@user)
    # @most_likes_user_name = Like.most_liked_user_name(@user)
    @like_datas = Like.count_like_datas(@user)
    # if user_ids.present?
    #   val = []
    #   # posts = Post.where(user_id: user_ids)（変更）
    #   posts = Post.discard_users_posts(user_ids)
    #   posts.each do |post|
    #     val.append(post.id) #論理削除されているuserの投稿のid(post.id）を取得している
    #   end
    #   # @likes = Like.where(user_id: @user.id).where.not(post_id: val).page(params[:page]).per(10)（変更）
    #   @likes = Like.user_like_posts(@user, val).page(params[:page]).per(10)
    #   @posts = @likes.map {|like| Post.find_by(id: like.post_id)}.reject(&:blank?)（変更）
    #   # @posts = []
    #   # @likes.each do |like|
    #   #   post = Post.find_by(id: like.post_id)
    #   #   next if post.blank?
    #   #   @posts.push(post)
    #   # end
    # else
    #   @likes = Like.where(user_id: @user.id).page(params[:page]).per(10)
    #   @posts = []
    #   @likes.each do |like|
    #     post = Post.find_by(id: like.post_id)
    #     next if post.blank?
    #     @posts.push(post)
    #   end
    # end
    # @posts.sort!.reverse!
    # @posts = Post.where(id: @user.likes.pluck(:post_id)).page(params[:page]).per(10)

    # @posts = Post.joins(:likes, :user)
    #               .select('posts.*')
    #               .where(likes: {user_id: @user.id})
    #               .page(params[:page])
    #               .per(10)
    @posts = Post.joins(:likes, :user)
                  .select('posts.*, users.image_name, users.name AS user_name')
                  .where(likes: {user_id: @user.id})
                  .page(params[:page])
                  .per(10)
  end

  def ensure_current_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def discard
    # @user = User.find params[:id]（変更）
    @user.discard
    session[:user_id] = nil
    flash[:notice] = "アカウントを削除しました。削除から10日以内であればアカウントの復元が可能です。"
    redirect_to("/login")
  end

  private

  def undiscard
    user = User.with_discarded.discarded.find_by(email: params[:email])
    if user.present?
      if user.authenticate(params[:password])
        discarded_at = user.discarded_at.strftime("%Y/%m/%d")
        d = Date.today
        dt = (d - 10).strftime("%Y/%m/%d")
        if user.present? && discarded_at > dt
          user.undiscard
        else
          user = nil
        end
        return user
      end
    end
  end

  # 基本情報のストロングパラメータ
  def user_params
    params.permit(
      :name, :email, :password, :password_confirmation, :code, :age, :year,
      :month, :gender, :prefecture_id
    # mergeメソッドは、paramsにはないレコード作成時に追加したい値を含めることができる
    # image_nameをユーザーid.jpgにする
    ).merge(image_name: "#{@current_user.id}.jpg")
  end

  # 詳細情報のストロングパラメータ
  def detail_params
    params.permit(:profile, :url)
  end

  def items
    params.permit(
      :name, :email, :code, :age_id, :prefecture_id, :year, :month, :period,
      :page, :limit, {is_posts: []}, {gender: []}
    )
  end

  def search_items
    {
      name: items[:name],
      email: items[:email],
      code: items[:code],
      age_id: items[:age_id],
      prefecture_id: items[:prefecture_id],
      year: items[:year],
      month: items[:month],
      period: items[:period],
      page: items[:page].nil? ? 0 : items[:page],
      limit: items[:limit].nil? ? 10 : items[:limit],
      is_posts: items[:is_posts],
      gender: items[:gender]
    }
  end
end
