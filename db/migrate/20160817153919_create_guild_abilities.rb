class CreateGuildAbilities < ActiveRecord::Migration[5.0]
  def change
    create_table :guild_abilities do |t|
      t.string :name
      t.integer :rep_cost
      t.text :description
      t.hstore :effect

      t.timestamps
    end
  end
end
