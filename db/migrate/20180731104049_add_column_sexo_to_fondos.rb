class AddColumnSexoToFondos < ActiveRecord::Migration[5.2]
  def change
    enable_extension "hstore"
    add_column :fondos, :sexos, :hstore
    add_index :fondos, :sexos, using: :gin
  end
end
