class AddColumnToFondos < ActiveRecord::Migration[5.2]
  def change
    add_column :fondos, :agno, :integer
  end
end
