class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string :name
      t.integer :total_xp
      t.integer :spent_xp
      t.integer :hiring_cost
      t.integer :upkeep_cost
      t.integer :max_hp
      t.integer :current_hp
      t.integer :max_sp
      t.integer :current_sp
      t.integer :strength
      t.integer :agility
      t.integer :vitality
      t.integer :stamina
      t.integer :intelligence
      t.integer :focus
      t.integer :focus
      t.integer :dodge
      t.integer :resilience
      t.integer :resist
      t.hstore :effects
      t.references :guild, foreign_key: true
      t.references :guild_hall, foreign_key: true
      t.references :location, foreign_key: true
      t.references :activity, foreign_key: true

      t.timestamps
    end
  end
end
