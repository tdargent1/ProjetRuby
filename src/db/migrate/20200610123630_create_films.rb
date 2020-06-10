class CreateFilms < ActiveRecord::Migration[6.0]
  require 'faker'

  def change
    create_table :films do |t|
      t.string :titre
      t.string :realisateur

      t.timestamps
    end

    (1..50).each do |x|
      Film.create(
        titre: Faker::Book.title,
        realisateur: Faker::Name.name
      )
    end
  end
end
