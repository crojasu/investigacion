class AddReferenceToPeliculas < ActiveRecord::Migration[5.2]
  def change
    add_reference :peliculas, :fondo, foreign_key: true
  end
end
