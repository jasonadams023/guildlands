class CreateRoomInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :room_inventories do |t|
      t.references :guild_hall, foreign_key: true
      t.references :room, foreign_key: true
      t.hstore :modifications

      t.timestamps
    end
  end
end
