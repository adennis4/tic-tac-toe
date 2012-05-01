class GameBoard < ActiveRecord::Base
  attr_accessible :current_state
  serialize :current_state, Array
  
  def start_game
    self.current_state = Array.new(9)
  end
end
