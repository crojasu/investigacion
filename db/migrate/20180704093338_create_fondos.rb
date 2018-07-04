class CreateFondos < ActiveRecord::Migration[5.2]
  def change
    create_table :fondos do |t|
      t.string :tipo
      t.integer :monto
      t.references :pelicula, foreign_key: true

      t.timestamps
    end
  end
end
