class AddColumnSexosToFondos < ActiveRecord::Migration[5.2]
  def change
    add_column :fondos, :sexo, :string
  end
end
