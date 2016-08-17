class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.hstore :effects
      t.string :category
      t.integer :value

      t.timestamps
    end
  end
end
