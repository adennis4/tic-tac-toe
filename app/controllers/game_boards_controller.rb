class GameBoardsController < ApplicationController
  
  def new
    @game = GameBoard.create
    @game.start_game
    @game.save
  end
  
  def show
    @game = GameBoard.find(params[:id])
    if @game.players.first.mark == "O" && @game.current_state.compact.count == 0
      computer_move
    end
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
    if @game.current_state.compact.count < 2
      first_move
    elsif @game.current_state[random_spot] == nil
      @game.current_state[random_spot] = @game.players.last.mark
    elsif @game.current_state.compact.count < 9
      computer_move
    else
      puts "This game is OVER"
    end
    @game.save
  end
  
  private
      
      def first_move
        if @game.current_state[4] == nil
          @game.current_state[4] = @game.players.last.mark
        else
          @game.current_state[0] = @game.players.last.mark
        end
      end
end
