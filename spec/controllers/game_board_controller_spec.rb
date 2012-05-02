require 'spec_helper'

describe GameBoardController do
  
  describe "GET new" do
    it "assigns a player and computer to each Game" do
      get :new
      assigns(:current_state).count.should eq(9)
    end
  end
  
  describe "GET index" do
    it "displays the current_state of the Game" do
      makes_move()
      get :index
      assigns(:current_state).count.should eq(2)
    end
  end

end
