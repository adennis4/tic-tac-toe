class PlayersController < ApplicationController
  
  def create
    game = GameBoard.find(params[:player][:game_board_id])
    @player = game.players.create(:mark => params[:player][:mark])
    
    if @player.mark == "X"
      game.players.create(:mark => "O")
      flash[:notice] = flash_x
    elsif @player.mark == "O"
      game.players.create(:mark => "X")
      flash[:notice] = flash_o
    else
      flash[:error] = flash_repick
      redirect_to root_path
      return
    end  
    redirect_to game_board_path(game.id)
  end
  
  private
  
  def flash_x
    "You selected to play as #{@player.mark}.  Best of Luck!!! I'll let you go first."
  end
  
  def flash_o
    "You selected to play as #{@player.mark}.  Letting me go first?  I'll take the middle square."
  end
  
  def flash_repick
    'You must select a capital "X" or a capital "O"'
  end
end

  
