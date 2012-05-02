class PlayersController < ApplicationController
  
  def create
    game = GameBoard.find(params[:player][:game_board_id])
    game.players.create
    redirect_to game_board_path(game.id)
  end
end
