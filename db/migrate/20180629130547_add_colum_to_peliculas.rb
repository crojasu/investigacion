class AddColumToPeliculas < ActiveRecord::Migration[5.2]
  def change
    add_column :peliculas, :contacto, :string
  end
end
