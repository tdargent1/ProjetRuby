class CreateFilms < ActiveRecord::Migration[6.0]
  def change
    create_table :films do |t|
      t.string :titre
      t.string :realisateur

      t.timestamps
    end
  end
end
