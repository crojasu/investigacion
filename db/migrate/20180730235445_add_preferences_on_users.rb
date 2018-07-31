class AddPreferencesOnUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension "hstore"
    add_column :peliculas, :sexos, :hstore
    add_index :peliculas, :sexos, using: :gin
  end
end
