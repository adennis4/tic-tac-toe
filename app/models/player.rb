class Player < ActiveRecord::Base
  attr_accessible :game_id, :mark
  
  belongs_to :game_board
  
  def select_mark
    @mark = "X"
  end
end
