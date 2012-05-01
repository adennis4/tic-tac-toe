class AddMark < ActiveRecord::Migration
  def up
    add_column :players, :mark, :string
  end

  def down
  end
end
