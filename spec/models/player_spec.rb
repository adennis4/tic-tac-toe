require 'spec_helper'

describe Player do
  before do
    @player1 = Player.create
    @player1.select_mark
  end
  
  it 'selects X or O' do
    @player1.mark = "X"
  end
end
