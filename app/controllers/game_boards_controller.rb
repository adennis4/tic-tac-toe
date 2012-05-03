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
    # generate
    # puts "#{@game.minimax_moves.max}"
    
    random_spot = rand(9)
     if @game.current_state.compact.count < 2
       first_move
     # else
     #   best_move
     # end
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
          
      def generate
        initial = GameBoard.new
        generate_moves(initial)
        @player = 'X'
        initial
      end
      
      def generate_moves(game_state)
        next_player = (@player == 'X' ? 'O' : 'X')
        game_state.current_state.each_with_index do |mark_at_position, position|
          unless mark_at_position
            next_state = game_state.current_state.dup
            next_state[position] = next_player
            
            next_game_board = GameBoard.new
            dup_state = next_game_board.current_state = next_state
            @player = next_player
            game_state.minimax_moves << dup_state
            
            generate_moves(next_game_board)
          end
        end
      end
end
