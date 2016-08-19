class CreateMarketOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :market_orders do |t|
      t.references :guild_hall, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :amount
      t.integer :price

      t.timestamps
    end
  end
end
