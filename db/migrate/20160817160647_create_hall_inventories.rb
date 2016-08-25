class CreateHallInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :hall_inventories do |t|
      t.references :guild_hall, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :total
      t.integer :available
      t.integer :selling
      t.integer :using

      t.timestamps
    end
  end
end
