class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit, :create, :update]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    # ログインユーザーが担当者または作成者のタスクのみ表示
    # ガントチャートと同じ期間仕様で表示期間を制限
    base_tasks = Task.includes(:user, :creator)
                    .where("user_id = ? OR creator_id = ?", @current_user.id, @current_user.id)
    
    # ガントチャートと同じ期間計算ロジック
    tasks_with_dates = base_tasks.where.not(start_date: nil, due_date: nil)
    
    if tasks_with_dates.any?
      earliest_start = tasks_with_dates.minimum(:start_date)
      latest_end = tasks_with_dates.maximum(:due_date)
      task_span = (latest_end - earliest_start).to_i
      
      if task_span <= 365
        # 1年以内の場合は、少し余白を追加してタスク期間を表示
        display_start = earliest_start - 7.days
        display_end = latest_end + 7.days
      else
        # 1年を超える場合は、最も早いタスクから1年間表示
        display_start = earliest_start - 7.days
        display_end = display_start + 365.days
      end
      
      # 表示期間内のタスクのみ表示
      @tasks = base_tasks.where(
        "(start_date IS NULL OR start_date <= ?) AND (due_date IS NULL OR due_date >= ?)",
        display_end, display_start
      ).order(due_date: :asc, priority: :desc)
    else
      # 日付設定のないタスクのみの場合は全て表示
      @tasks = base_tasks.order(due_date: :asc, priority: :desc)
    end
  end

  def gantt
    # ログインユーザーが担当者または作成者のタスクで、かつ日付が設定されているもののみ表示
    tasks_with_dates = Task.where("user_id = ? OR creator_id = ?", @current_user.id, @current_user.id)
                          .where.not(start_date: nil, due_date: nil)
                          
    # 本日から期限が近い順にソート（期限が過ぎているものも含む）
    today = Date.current
    sorted_tasks = tasks_with_dates.sort_by do |task|
      days_until_due = (task.due_date - today).to_i
      # 期限が近い順（負の値は期限切れ、正の値は今後の期限）
      [days_until_due.abs, days_until_due]
    end
    
    @chart_data = sorted_tasks.map do |task|
      {
        id: task.id.to_s,
        name: task.title,
        start: task.start_date.strftime('%Y-%m-%d'),
        end: task.due_date.strftime('%Y-%m-%d'), # 終了日そのものを指定
        progress: task.completed? ? 100 : (task.in_progress? ? 50 : 0),
        custom_class: task.priority
      }
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = @current_user.created_tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'タスクを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'タスクを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'タスクを削除しました。' }
      format.turbo_stream { redirect_to tasks_url, notice: 'タスクを削除しました。' }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_users
    @users = User.order(:id)
  end

  def task_params
    params.require(:task).permit(
      :title, :description, :status, :priority, :start_date, :due_date, :user_id
    )
  end

  def ensure_correct_user
    # タスクの作成者または担当者のみが編集・削除できる
    unless @task.creator_id == @current_user.id || @task.user_id == @current_user.id
      flash[:alert] = '権限がありません。'
      redirect_to tasks_path
    end
  end
end