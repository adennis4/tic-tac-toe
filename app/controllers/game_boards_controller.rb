class GameBoardsController < ApplicationController
  
  def new
    @game = GameBoard.create
    @game.start_game
  end
  
  def show
    @game = GameBoard.find(params[:id])
    if @game.game_finished && @game.winner
      flash[:notice] = "GAME OVER - I WIN!!!"
    elsif @game.players.first.mark == "O" && @game.current_state.compact.count == 0
      computer_move
    end
  end
  
  def update
    @game = GameBoard.find(params[:id])
      selection = (params[:game_board][:selection]).to_i
      mark = @game.players.first.mark 
      if @game.current_state[selection] == nil
        @game.makes_move(mark, selection)
        computer_move
        redirect_to game_board_path
      else
        flash[:error] = "This spot was already taken. Your probably should pick a new one."
        redirect_to game_board_path
      end
  end
  
  private
  
      def computer_move
        if @game.draw
          flash[:notice] = "The Game ended in a Draw.  Let's Play Again."
        else
          best_move
        end
        @game.save
      end
  
      def best_move
        @game.players.first.mark = "X" ? @value = -1 : @value = 1
        if @game.current_state.compact.count < 2
          first_move
        else
          current_player
          mini_max_move(@value, 0, 0)
          @game.current_state[@position] = @game.players.last.mark 
        end
      end

      
      def first_move
        if @game.current_state[4] == nil
          @game.current_state[4] = @game.players.last.mark
        else
          @game.current_state[0] = @game.players.last.mark
        end
      end
  
      def mini_max_move(value, best_score, iteration)
        @current_mark = @current_mark == "X" ? "O" : "X"
        count = 0
        (0..8).each do |position|
          @score = 0
          if @game.current_state[position] == nil
            @game.current_state[position] = @current_mark
            if !@game.game_finished
              mid_game_score(value, best_score, iteration)
            elsif @game.winner
              final_game_score(value, iteration, position)
            end                  
            best_score = update_best_score(value, @score, best_score, iteration, count, position)
            count += 1
            @game.current_state[position] = nil
          end
        end
        best_score
      end
  
      def current_player
        @current_mark = @game.players.first.mark
      end
      
      def mid_game_score(value, best_score, iteration)
        @score += mini_max_move(-@value, best_score, iteration+1)
      end
      
      def final_game_score(value, iteration, position)
        @score += value/@value
        return @score if win_on_next_move(iteration, position)
      end
  
      def update_best_score(value, score, best_score, iteration, count, position)
        if count == 0 or (score > best_score and value == 1) or (score < best_score and value = -1)
          best_score = score
          @position = position if iteration == 0
        end
        best_score
      end

      def win_on_next_move(iteration, position)
        if iteration == 0
          @position = position
          return true
        end
        false
      end
    end
