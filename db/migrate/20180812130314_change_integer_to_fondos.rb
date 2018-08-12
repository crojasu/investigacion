class ChangeIntegerToFondos < ActiveRecord::Migration[5.2]
  def change
    change_column :fondos, :monto, :float
  end
end
