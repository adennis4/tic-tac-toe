class Player < ActiveRecord::Base
  attr_accessible :game_board_id, :mark
  
  belongs_to :game_board
end
