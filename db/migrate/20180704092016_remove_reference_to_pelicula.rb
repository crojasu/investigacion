class RemoveReferenceToPelicula < ActiveRecord::Migration[5.2]
  def change
    remove_reference :peliculas, :fondo, index: true
  end
end
