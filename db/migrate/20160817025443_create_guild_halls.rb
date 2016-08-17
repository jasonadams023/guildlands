class CreateGuildHalls < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'
    create_table :guild_halls do |t|
      t.string :name
      t.integer :size
      t.integer :unit_limit
      t.hstore :effects
      t.references :guild, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
