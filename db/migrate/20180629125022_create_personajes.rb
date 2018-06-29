class CreatePersonajes < ActiveRecord::Migration[5.2]
  def change
    create_table :personajes do |t|
      t.string :name
      t.boolean :genero, default: false

      t.timestamps
    end
  end
end
