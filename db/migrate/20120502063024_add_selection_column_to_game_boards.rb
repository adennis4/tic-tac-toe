class AddSelectionColumnToGameBoards < ActiveRecord::Migration
  def change
    add_column :game_boards, :selection, :integer
  end
end
