require 'spec_helper'

describe GameBoard do
  
  context 'game_start' do
    it 'has 9 positions' do
      game1 = GameBoard.create
      game1.start_game
      game1.current_state.count.should eq(9)
    end
  
    it 'starting positions have no values' do
      game1 = GameBoard.create
      game1.start_game
      game1.current_state.compact.should be_empty
    end
  end
end
