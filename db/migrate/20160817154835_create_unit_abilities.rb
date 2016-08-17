class CreateUnitAbilities < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_abilities do |t|
      t.string :name
      t.integer :xp_cost
      t.string :category
      t.integer :ap_cost
      t.integer :sp_cost
      t.text :description
      t.hstore :effects

      t.timestamps
    end
  end
end
