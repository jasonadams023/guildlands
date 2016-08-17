class CreateGuilds < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'
    create_table :guilds do |t|
      t.string :name
      t.integer :total_rep
      t.integer :spent_rep
      t.integer :money
      t.hstore :effects, using: :gin

      t.timestamps
    end
  end
end
