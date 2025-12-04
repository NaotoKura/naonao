class PostsController < ApplicationController
  require 'natto'

  before_action :authenticate_user
  before_action :ensure_current_user, {only: [:edit, :edit_fixed, :update, :destroy]}
  before_action :post_info, {only: [:show, :edit, :update, :destroy]}

  # 退会したユーザーの投稿も10日間表示する。
  def index
    # user_ids = User.with_discarded.discarded.ids
    # # 論理削除されたユーザーのid以外のpost.user_idを取得して表示したい
    # if user_ids.present?
    #   @posts = Post.where.not(user_id: user_ids).order(created_at: :desc).page(params[:page]).per(10)
    # else
    #   @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    # end
    # @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    @posts = Post.order(created_at: :desc)
                  .joins(:user)
                  .select("posts.*, users.image_name, users.name as user_name")
                  .page(params[:page])
                  .per(1)
  end


  def show
    # @post = Post.find params[:id]
    # if @post.blank?
    #   render_404
    # else
    #   @user = @post.user
    #   @likes_count = Like.where(post_id: @post.id).length
    # end
    return render_404 if @post.blank?
    # @user = @post.user
    @likes_count = Like.where(post_id: @post.id).length
  end

  def new
    @post = Post.new
  end

  # def new_fixed
  #   @post = Post.new
  # end

  def create
    p "=============================================="
    pp params
    p "=============================================="
    @post = Post.new(
      work_content: params[:work_content],
      content: params[:content],
      study_content: params[:study_content],
      notices_content: params[:notices_content],
      user_id: @current_user.id
    )
    # if @post.save
    #   flash[:notice] = "投稿を作成しました"
    #   redirect_to("/posts/index")
    # else
    #   render("posts/new")
    # end
    p "=============================================="
    pp @post.save
    p "=============================================="
    if @post.save
      if params[:type].blank?
        flash[:notice] = "投稿を作成しました"
        return redirect_to("/posts/index")
      end
      return render("posts/new")
    end
    render("posts/new")
  end

  def edit
    # @post = Post.find params[:id]
  end

  # def edit_fixed
  #   # @post = Post.find params[:id]
  # end

  def update
    # @post = Post.find params[:id]
    # @post.content = params[:content]
    @post.work_content = params[:work_content]
    @post.content = params[:content]
    @post.study_content = params[:study_content]
    @post.notices_content = params[:notices_content]
    # if @post.save
    #   flash[:notice] = "投稿を編集しました"
    #   redirect_to("/posts/index")
    # else
    #   render("posts/edit")
    # end
    if @post.save
      if params[:type].blank?
        flash[:notice] = "投稿を編集しました"
        return redirect_to("/posts/index")
      end
      return render("posts/edit")
    end
    render("posts/edit")
  end

  def destroy
    # @post = Post.find params[:id]
    p "=============================================="
    pp @post
    p "=============================================="
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_current_user
    @post = Post.find params[:id]
    if @current_user.id != @post.user_id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def word_cloud
    post_content = Post.pluck(:content).join("\n")
    words = extract_words(post_content)
    render json: words
  end

  private

  def extract_words(text)
    nm = Natto::MeCab.new
    freq = Hash.new(0)
    nm.parse(text) do |n|
      next if n.surface.empty? || n.feature.include?("記号")
      freq[n.surface] += 1
    end
    freq.map { |word, count| { text: word, size: count * 10 } }
  end
end
