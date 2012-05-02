class PlayersController < ApplicationController
  
  def create
    game = GameBoard.find(params[:player][:game_board_id])
    @player = game.players.create(:mark => params[:player][:mark])
    if @player.mark.downcase == "x"
      @computer = game.players.create(:mark => "O")
    else
      @computer = game.players.create(:mark => "X")
    end  
    redirect_to game_board_path(game.id)
  end
end

  
