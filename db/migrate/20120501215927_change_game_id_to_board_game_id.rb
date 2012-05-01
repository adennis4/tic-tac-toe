class ChangeGameIdToBoardGameId < ActiveRecord::Migration
  def up
    rename_column :players, :game_id, :board_game_id
  end

  def down
  end
end
