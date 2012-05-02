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
    computer_move
    redirect_to game_board_path
  end
  
  def computer_move
    random_spot = rand(9)
    if @game.current_state[random_spot] == nil
      @game.current_state[random_spot] = @game.players.last.mark
    elsif @game.current_state.compact.count < 9
      computer_move
    else
      puts "This game is OVER"
    end
    @game.save
  end
end
