class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.references :guild, foreign_key: true
      t.integer :turn
      t.text :message
      t.hstore :data

      t.timestamps
    end
  end
end
