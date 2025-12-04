class ApplicationController < ActionController::Base
  before_action :set_current_user
  rescue_from ActiveRecord::RecordNotFound,   with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/posts/index")
    end
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  # ユーザーの情報を取得する
  def user_info
    @user = User.find params[:id]
  end

  def post_info
    @post = Post.find params[:id]
  end

  def schedule_info
    @schedule = Schedule.find params[:id]
  end

  def memo_info
    @memo = Memo.find_by(schedule_id: params[:id])
  end

  # def orgjjg
  #   p "=============================="
  #   p "=============================="
  #   p "=============================="
  # end

  private

  def render_404
    render 'error/404', status: :not_found
  end

  def render_500
    render 'error/500', status: :internal_server_error
  end

end
