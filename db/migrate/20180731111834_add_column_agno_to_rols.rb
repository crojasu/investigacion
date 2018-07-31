class AddColumnAgnoToRols < ActiveRecord::Migration[5.2]
  def change
    add_column :rols, :ano, :string
  end
end
