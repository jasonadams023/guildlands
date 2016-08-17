class CreateLocations < ActiveRecord::Migration[5.0]
  def change
  	enable_extension 'hstore'
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.hstore :effects

      t.timestamps
    end
  end
end
