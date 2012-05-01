class CreateGameBoards < ActiveRecord::Migration
  def change
    create_table :game_boards do |t|
      t.text :current_state

      t.timestamps
    end
  end
end
