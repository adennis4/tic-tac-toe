require 'spec_helper'

describe GameBoard do
  before do
    @game1 = GameBoard.create
    @game1.start_game
  end
  
  context 'game_start' do
    it 'has 9 positions' do
      @game1.current_state.count.should eq(9)
    end
  
    it 'starting positions have no values' do
      @game1.current_state.compact.should be_empty
    end
  end
  
  context 'makes_move' do
    it 'marks a given position' do
      @game1.makes_move("X", 1)
      @game1.current_state[1].should == "X"
    end
    
    it 'raises an error for a position that is already taken' do
      good_move = @game1.makes_move("X", 4)
      bad_move  = @game1.makes_move("X", 4)
      
      bad_move.should be_instance_of(String)
    end
  end
  
  context 'win' do
    it 'recognizes a win for three consecutive marks' do
      @game1.makes_move("X", 0)
      @game1.makes_move("X", 3)
      @game1.makes_move("X", 6)
      @game1.game_result.should be_true
    end

  end
end
