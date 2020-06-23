class AddHolderToFilms < ActiveRecord::Migration[6.0]
  def change
    add_column :films, :holder, :integer, default: nil
  end
end
