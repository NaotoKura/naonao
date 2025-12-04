class SchedulesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_current_user, {only: [:edit, :edit_fixed, :update, :destroy]}
  before_action :schedule_info, {only: [:show, :edit, :update, :destroy]}

  # 退会したユーザーの投稿も10日間表示する。
  def index
    require 'date'

    date = params[:date] ? Date.parse(params[:date]) : Date.today
    @date = params[:change] ? date + params[:change].to_i : date
    @schedules = Schedule.search_schedule(@date).order_by_asc
  end

  def show
    return render_404 if @schedule.blank?
  end

  def new
    require 'date'

    @today = Date.today
    @schedule = Schedule.new
    @hours = (0..23).to_a.product([0, 15, 30, 45]).map {
      |h, m| format('%02d', h) + ":#{format('%02d', m)}"
    }
  end

  def create
    schedule_params[:category].each_with_index do |category, index|
      @schedule = Schedule.create(
        category: category,
        start_time: schedule_params[:start_time][index],
        end_time: schedule_params[:end_time][index],
        content: schedule_params[:content][index],
        deadline: schedule_params[:deadline][index],
        date: schedule_params[:date][index],
        user_id: @current_user.id
      )
      @memo = Memo.create(
        schedule_id: @schedule.id
      )
      flash[:notice] = "投稿を作成しました"
    end
    redirect_to("/schedules/index")
  end

  def edit_by_date
    require 'date'

    @today = Date.today
    @schedule = Schedule.new
    @schedules = Schedule.where(date: params[:date])
    @hours = (0..23).to_a.product([0, 15, 30, 45]).map {
      |h, m| format('%02d', h) + ":#{format('%02d', m)}"
    }
    if @schedules.nil?
      render 'error/404', status: :not_found
    end
  end

  def update_by_date
    params[:ids].each_with_index do |id, index|
      schedule = Schedule.find_by(id: id)
      next if schedule.nil?  # 存在しないIDはスキップ

      schedule.update(
          category: schedule_params[:category][index],
          start_time: schedule_params[:start_time][index],
          end_time: schedule_params[:end_time][index],
          content: schedule_params[:content][index],
          deadline: schedule_params[:deadline][index],
          date: schedule_params[:date][index],
        )
    end
    flash[:notice] = "更新しました"
    redirect_to("/schedules/index")
  end

  def destroy
    @schedule.destroy
    flash[:notice] = "スケジュールを削除しました"
    redirect_to("/schedules/index")
  end

  def ensure_current_user
    @schedule = Schedule.find params[:id]
    if @current_user.id != @schedule.user_id
      flash[:notice] = "権限がありません"
      redirect_to("/schedule/index")
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(
      category: [],
      start_time: [],
      end_time: [],
      content: [],
      deadline: [],
      date: [],
    )
  end
end


