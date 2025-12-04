class MemosController < ApplicationController
  before_action :authenticate_user
  before_action :memo_info, {only: [:show, :edit, :update, :destroy]}
  before_action :schedule_info, {only: [:new, :create]}

  def index
    @memos = Memo.includes(:schedule).where(schedule: {user_id: @current_user.id})
  end

  def show
  end

  def new
    @memo = Memo.new
  end

  def create
    @memo = Memo.new(memo_params)
    @memo.schedule_id = params[:schedule_id] || params[:memo][:schedule_id]
    
    if @memo.save
      flash[:notice] = "メモを作成しました"
      redirect_to(memo_path(@memo))
    else
      @schedule = Schedule.find(@memo.schedule_id) if @memo.schedule_id
      render("memos/new")
    end
  end

  def edit
  end

  def update
    if @memo.update(memo_params)
      flash[:notice] = "メモを更新しました"
      redirect_to(memo_path(@memo))
    else
      render("memos/edit")
    end
  end

  def destroy
    @memo.destroy
    flash[:notice] = "メモを削除しました"
    redirect_to(memos_path)
  end

  private

  def memo_params
    params.require(:memo).permit(:memo, :schedule_id)
  end

  def schedule_info
    @schedule = Schedule.find(params[:schedule_id])
  end

  def memo_info
    @memo = Memo.find_by(id: params[:id])
    if @memo.nil?
      flash[:notice] = "指定されたメモが見つかりません"
      redirect_to(memos_path)
    end
  end
end


