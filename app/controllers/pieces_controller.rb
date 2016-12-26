class PiecesController < ApplicationController
  before_action :set_game
  def update
    if selected_piece.move_to(params[:piece][:x_position].to_i,params[:piece][:y_position].to_i)
      if selected_piece.game.has_started == false
        selected_piece.game.has_started = true
        selected_piece.game.save
        Pusher["broadcast_#{@game.id}"].trigger!('game_has_started',{game_has_started: true})
      end
      
      if selected_piece.game.is_blitz
        @white_timer = selected_piece.game.timers.where(player_id: selected_piece.game.white_player_id).last
        @black_timer = selected_piece.game.timers.where(player_id: selected_piece.game.black_player_id).last
        if selected_piece.game.current_turn == selected_piece.game.black_player_id
          @black_timer.start!
          @white_timer.stop!
        else
          @white_timer.start!
          @black_timer.stop!
        end
        Pusher["broadcast_#{@game.id}"].trigger!('change_turns',{timer: {white_start_time: @white_timer.start_time, black_start_time: @black_timer.start_time, black_time_left: @black_timer.time_left,white_time_left: @white_timer.time_left}, current_turn: selected_piece.game.current_player_turn })
        render json: {}, status: :ok
      else
        render json: {}, status: :ok
      end
    else
      render json: {response: {error: 'Invalid Move'}}, status: :unprocessable_entity
    end
  end
  
  private
  
  def piece_params
    params.require(:piece).permit(:x_position,:y_position)
  end
  
  def selected_piece
    @selected_piece ||= Piece.find(params[:id])
  end
  
  def set_game
    @game ||= Game.find(params[:game_id])
  end

end
