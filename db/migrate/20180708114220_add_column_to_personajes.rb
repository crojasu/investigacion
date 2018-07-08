class AddColumnToPersonajes < ActiveRecord::Migration[5.2]
  def change
    add_column :personajes, :genero, :string, default: "Hombre"
  end
end
