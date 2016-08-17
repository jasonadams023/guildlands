class CreateJoinTableGuildGuildAbility < ActiveRecord::Migration[5.0]
  def change
    create_join_table :guilds, :guild_abilities do |t|
      # t.index [:guild_id, :guild_ability_id]
      # t.index [:guild_ability_id, :guild_id]
    end
  end
end
