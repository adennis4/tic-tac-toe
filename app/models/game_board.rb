class GameBoard < ActiveRecord::Base
  attr_accessible :current_state, :selection, :minimax_moves
  serialize :current_state, Array   
  
  has_many :players
  
  def start_game
    self.current_state = Array.new(9)
  end
  
  def makes_move(mark, position)
    current_state[position] = mark
  end

  def winner
    winning_combos = [ [0, 1, 2], [3, 4, 5], [6, 7, 8],
                       [0, 3, 6], [1, 4, 7], [2, 5, 8],
                       [0, 4, 8], [2, 4, 6] ]
    winner = winning_combos.map { |winning_combo|
                                             (current_state[winning_combo[0]] != nil && 
                                              current_state[winning_combo[0]] == current_state[winning_combo[1]] &&
                                              current_state[winning_combo[1]] == current_state[winning_combo[2]]) || nil
                                             }
    winner.include? true
  end
  
  def draw
    current_state.compact.count == 9 && winner == false ? true : false
  end
  
  def game_finished
    winner || draw
  end
  
  def computer_move
    if game_finished
      save
    else
      best_move
    end
    save
  end

  def best_move
    players.first.mark = "X" ? @value = -1 : @value = 1
    if current_state.compact.count < 2
      first_move
    else
      mini_max_move(@value, 0, 0)
      current_state[@position] = players.last.mark 
    end
  end

  def first_move
    if current_state[4] == nil
      current_state[4] = players.last.mark
    else
      current_state[0] = players.last.mark
    end
  end

  def mini_max_move(value, best_score, iteration)
    @current_mark = @current_mark == "X" ? "O" : "X"
    count = 0
    (0..8).each do |position|
      abc = [1]
      if current_state[position] == nil
        current_state[position] = @current_mark
        if !game_finished
          abc << mini_max_move(-value, best_score, iteration+1)
        else
          if winner
            abc << value
            score = abc.inject{ |sum, b| sum + b }
            return score if win_on_next_move(iteration, position)
          end
        end    
        score = abc.inject{ |sum, b| sum + b }       
        best_score = update_best_score(value, score, best_score, iteration, count, position)
        count += 1
        current_state[position] = nil
      end
    end
    best_score
  end

  def update_best_score(value, score, best_score, iteration, count, position)
    if count == 0 or (score > best_score and value == @value) or (score < best_score and value = @value)
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
