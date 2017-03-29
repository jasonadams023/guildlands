class CreateMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :maps do |t|
      t.references :guild, foreign_key: true
      t.string :name
      t.integer :dimensions, array: true, default: []
      t.text :tile_types, array: true, default: []

      t.timestamps
    end
  end
end
