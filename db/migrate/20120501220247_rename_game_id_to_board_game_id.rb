class RenameGameIdToBoardGameId < ActiveRecord::Migration
  def up
    rename_column :players, :board_game_id, :game_board_id
  end

  def down
  end
end
