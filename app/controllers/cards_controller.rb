class CardsController < ApplicationController
      before_action :authenticate_user
      
      def new
        @lane = Lane.find(params[:lane_id])
        @card = @lane.cards.new
      end

      def create
        @lane = Lane.find(params[:lane_id])
        @card = @lane.cards.new(card_params)
        
        if @card.save
          # 成功時はTurbo Streamを返す
          respond_to do |format|
            format.turbo_stream
          end
        else
          # 失敗時はフォームを再表示
          render :new, status: :unprocessable_entity
        end
      end

      def move
        card = Card.find(params[:id])
        # 所属レーンと表示順を更新
        card.update(lane_id: params[:lane_id], position: params[:position])
        head :ok # 成功ステータスのみを返す
      end

      def destroy
        @card = Card.find(params[:id])
        @card.destroy
        respond_to do |format|
          format.turbo_stream
        end
      end

      private

      def card_params
        params.require(:card).permit(:title, :priority, :due_date)
      end
    end
