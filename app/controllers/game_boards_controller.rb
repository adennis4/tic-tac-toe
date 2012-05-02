class GameBoardsController < ApplicationController
  
  def new
    @game = GameBoard.create
    @game.start_game
    @game.save
  end
  
  def show
    @game = GameBoard.find(params[:id])
  end
  
  def update
    @game = GameBoard.find(params[:id])
    selection = (params[:game_board][:selection]).to_i
    @game.current_state[selection] = @game.players.first.mark
    @game.save
    redirect_to game_board_path
  end
end
