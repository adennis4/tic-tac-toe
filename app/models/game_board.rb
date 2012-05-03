class GameBoard < ActiveRecord::Base
  attr_accessible :current_state, :selection, :minimax_moves
  serialize :current_state, Array   
  
  has_many :players
  
  def start_game
    self.current_state = Array.new(9)
  end
  
  def makes_move(mark, posn)
    if current_state[posn] == nil
      current_state[posn] = mark
    else
      message = "This spot was already taken. Your probably should pick a new one"
    end
  end

  def winner
    winning_combos = [ [0, 1, 2], [3, 4, 5], [6, 7, 8],
                       [0, 3, 6], [1, 4, 7], [2, 5, 8],
                       [0, 4, 8], [2, 4, 6] ]
    winner = winning_combos.map { |w_combo|
                                             (current_state[w_combo[0]] != nil && 
                                              current_state[w_combo[0]] == current_state[w_combo[1]] &&
                                              current_state[w_combo[1]] == current_state[w_combo[2]]) || nil
                                             }
    winner.include? true
  end
  
  def draw
    current_state.compact.count == 9 && winner == false ? true : false
  end
  
  def game_finished
    winner || draw
  end
end
