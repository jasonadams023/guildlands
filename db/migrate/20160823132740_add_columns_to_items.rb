class AddColumnsToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :max_value, :integer
    add_column :items, :demand, :integer
  end
end
