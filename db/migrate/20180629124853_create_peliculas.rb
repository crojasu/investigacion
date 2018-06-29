class CreatePeliculas < ActiveRecord::Migration[5.2]
  def change
    create_table :peliculas do |t|
      t.string :titulo
      t.string :responsable
      t.integer :monto
      t.string :institucion
      t.integer :agno
      t.string :imbd
      t.integer :idcinechile

      t.timestamps
    end
  end
end
