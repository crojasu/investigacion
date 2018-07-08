class RemoveColumnToPersonajes < ActiveRecord::Migration[5.2]
  def change
    remove_column :personajes, :genero, :boolean
  end
end
