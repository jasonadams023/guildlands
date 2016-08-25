class CreateUnitInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_inventories do |t|
      t.references :unit, foreign_key: true
      t.references :hall_inventory, foreign_key: true
      t.integer :amount
      t.boolean :equipped

      t.timestamps
    end
  end
end
