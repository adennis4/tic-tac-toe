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
  end
  
  context 'win' do
    it 'returns true when game state matches a winning combo' do
      @game1.makes_move("X", 0)
      @game1.makes_move("X", 3)
      @game1.makes_move("X", 6)
      @game1.makes_move("O", 4)
      @game1.makes_move("O", 2)
      @game1.winner.should be_true
    end
    
    it 'returns false when not a win' do
      @game1.makes_move("X", 0)
      @game1.makes_move("X", 3)
      @game1.makes_move("O", 6)
      @game1.winner.should be_false
    end
  end
  
  context 'draw' do
    it 'returns true when all marks are made without a winner' do
      @game1.makes_move("O", 0)
      @game1.makes_move("X", 1)
      @game1.makes_move("O", 2)
      @game1.makes_move("O", 3)
      @game1.makes_move("X", 4)
      @game1.makes_move("X", 5)
      @game1.makes_move("X", 6)
      @game1.makes_move("O", 7)
      @game1.makes_move("X", 8)
      @game1.draw.should be_true
    end
    
    it 'returns false when a winner is made on the last possible move' do
      @game1.makes_move("O", 0)
      @game1.makes_move("X", 1)
      @game1.makes_move("O", 2)
      @game1.makes_move("O", 3)
      @game1.makes_move("X", 4)
      @game1.makes_move("X", 5)
      @game1.makes_move("X", 8)
      @game1.makes_move("O", 7)
      @game1.makes_move("O", 6)
      @game1.draw.should be_false
    end     
  end
  
  context 'game_finished' do
    it 'returns true if game is over with a win' do
      @game1.current_state = ["X", "X", "X", "O", "O", nil, nil, nil, nil]
      @game1.game_finished
      @game1.game_finished.should be_true
    end
    
    it 'returns true if game is over with a draw' do
      @game1.current_state = ["O", "X", "O", "O", "X", "X", "X", "O", "X"]
      @game1.game_finished
      @game1.game_finished.should be_true
    end
  end
  
  context 'first_move' do
    it 'selects the 4th board position if open' do
      Player.create(:game_board_id => @game1.id, :mark => "X")
      @game1.first_move
      @game1.current_state[4].should eq("X")
    end
    
    it 'selects the 0th board position if the 4th is taken' do
      Player.create(:game_board_id => @game1.id, :mark => "X")
      @game1.makes_move("O", 4)
      @game1.first_move
      @game1.current_state[0].should eq("X")
    end
  end
  
  context 'best_move' do
    it "calls first_move if it is computers first move" do
      Player.create(:game_board_id => @game1.id, :mark => "X")
      @game1.best_move
      @game1.current_state[4].should eq("X")
    end
  end
  
  context 'win_on_next_move' do
    it 'returns true if win is on next move' do
      @game1.win_on_next_move(0, 8).should be_true
    end
    
    it 'returns false if win is not on next move' do
      @game1.win_on_next_move(1, 8).should be_false
    end
  end
  
  
end
