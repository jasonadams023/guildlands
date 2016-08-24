class AddColumnsToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :category, :string
  end
end
