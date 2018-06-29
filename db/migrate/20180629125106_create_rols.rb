class CreateRols < ActiveRecord::Migration[5.2]
  def change
    create_table :rols do |t|
      t.string :name
      t.references :personaje, foreign_key: true
      t.references :pelicula, foreign_key: true

      t.timestamps
    end
  end
end
