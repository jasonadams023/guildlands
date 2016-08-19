class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :size
      t.integer :cost
      t.text :description
      t.hstore :effects

      t.timestamps
    end
  end
end
