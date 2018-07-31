class RemoveColumnsToPeliculas < ActiveRecord::Migration[5.2]
  def change
     remove_column :peliculas, :sexo
  end
end
