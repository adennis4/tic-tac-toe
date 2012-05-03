class AddMinimaxMovesToGameBoard < ActiveRecord::Migration
  def change
    add_column :game_boards, :minimax_moves, :text
  end
end
