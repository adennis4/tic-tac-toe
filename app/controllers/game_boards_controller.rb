class GameBoardsController < ApplicationController
  
  def new
    @game = GameBoard.create
    @game.start_game
  end
  
  def show
    @game = GameBoard.find(params[:id])
    if @game.game_finished
      flash[:notice] = "GAME OVER"
    elsif @game.players.first.mark == "O" && @game.current_state.compact.count == 0
      @game.computer_move
    end
  end
  
  def update
    @game = GameBoard.find(params[:id])
    selection = (params[:game_board][:selection]).to_i
    mark = @game.players.first.mark     
    if @game.current_state[selection] == nil
      @game.makes_move(mark, selection)
      @game.computer_move
    else
      flash[:error] = "This spot was already taken. You probably should pick a new one."
    end
    redirect_to game_board_path
  end
end