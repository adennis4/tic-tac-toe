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

  def winner?
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
  
  def draw?
    current_state.compact.count == 9 && !winner?
  end
  
  def game_finished?
    winner? || draw?
  end
  
  def computer_move
    if game_finished?
      save
    else
      best_move
    end
    save
  end

  def best_move
    if current_state.compact.count < 2
      first_move
    else
      best_move = mini_max_move(players.last.mark)
      current_state[best_move] = players.last.mark
    end
  end

  def first_move
    if current_state[4] == nil
      current_state[4] = players.last.mark
    else
      current_state[0] = players.last.mark
    end
  end

  def mini_max_move(player_mark)
    best_score = -10
    best_move = -1
      (0..8).each do |position|
        if current_state[position] == nil
          next_state = current_state.clone
          next_state[position] = player_mark
          score = check_score(next_state, 0, player_mark)
          if score > best_score
            best_score = score
            best_move = position
          end
        end
      end  
    return best_move
  end
  
  def check_score(simulation_state, iteration, player_mark)
    iteration += 1
    score_array = []
    player_mark = (player_mark == 'X' ? 'O' : 'X')
    
    if trial_game_finished?(simulation_state)
      if trial_winner?(simulation_state) && iteration % 2 == 1
        score = (10 - iteration)
      elsif trial_winner?(simulation_state) && iteration % 2 == 0
        score = -(10 - iteration)
      else
        score = 0
      end
      return score
    end
    
    (0..8).each do |position|
      score_array[position] = 0
      if simulation_state[position] == nil
        next_state = simulation_state.clone
        next_state[position] = player_mark
        score_array[position] = check_score(next_state, iteration, player_mark)
      end
    end
    
    if iteration % 2 == 0
      score_array.max
    else
      score_array.min
    end
  end
  
  def trial_game_finished?(simulation_state)
    trial_winner?(simulation_state) || trial_draw?(simulation_state)
  end
  
  def trial_winner?(simulation_state)
    winning_combos = [ [0, 1, 2], [3, 4, 5], [6, 7, 8],
                       [0, 3, 6], [1, 4, 7], [2, 5, 8],
                       [0, 4, 8], [2, 4, 6] ]
    winner = winning_combos.map { |winning_combo|
                                             (simulation_state[winning_combo[0]] != nil && 
                                              simulation_state[winning_combo[0]] == simulation_state[winning_combo[1]] &&
                                              simulation_state[winning_combo[1]] == simulation_state[winning_combo[2]]) || nil
                                             }
    winner.include? true
  end
  
  def trial_draw?(simulation_state)
    simulation_state.compact.count == 9 && !trial_winner?(simulation_state)
  end
end
