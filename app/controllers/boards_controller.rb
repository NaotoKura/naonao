class BoardsController < ApplicationController
  before_action :authenticate_user

  def show
    # ユーザーのボードがなければ作成する
    @board = @current_user.board || @current_user.create_board

    # 初回アクセス時にデフォルトのレーンを作成する
    if @board.lanes.empty?
      @board.lanes.create(name: 'ToDo', position: 1)
      @board.lanes.create(name: '進行中', position: 2)
      @board.lanes.create(name: '完了', position: 3)
    end

    # カード情報を含めてレーンを取得
    @lanes = @board.lanes.includes(:cards)
  end
end
