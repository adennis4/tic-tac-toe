require 'spec_helper'

describe GameBoardsController do
  
  describe "GET new" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    
    it "assigns a player and computer to each Game" do
      get :new
      assigns(:game).should be_instance_of(GameBoard)
    end
  end
end
