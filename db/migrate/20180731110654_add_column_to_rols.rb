class AddColumnToRols < ActiveRecord::Migration[5.2]
  def change
    add_column :rols, :sexo, :string
  end
end
