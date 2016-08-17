class CreateJoinTableUnitUnitAbility < ActiveRecord::Migration[5.0]
  def change
    create_join_table :units, :unit_abilities do |t|
      # t.index [:unit_id, :unit_ability_id]
      # t.index [:unit_ability_id, :unit_id]
    end
  end
end
