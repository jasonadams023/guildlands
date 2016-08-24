class CreateMarketOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :market_orders do |t|
      t.references :hall_inventory, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :amount
      t.integer :price
      t.integer :category #negative = selling, positive = buying, 0 = neither

      t.timestamps
    end
  end
end
