class RemoveColumns < ActiveRecord::Migration[5.2]
  def change
     remove_column :peliculas, :monto
     remove_column :peliculas, :institucion
  end
end
