class AddColumnToPeliculas < ActiveRecord::Migration[5.2]
  def change
    add_column :peliculas, :tipo, :string
    add_column :peliculas, :salas, :integer
    add_column :peliculas, :copias, :integer
    add_column :peliculas, :publico, :integer
  end
end
