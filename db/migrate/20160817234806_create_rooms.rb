class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :size
      t.text :descritption
      t.hstore :effects

      t.timestamps
    end
  end
end
