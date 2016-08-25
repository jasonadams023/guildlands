class UnitInventory < ApplicationRecord
  belongs_to :unit
  belongs_to :hall_inventory
end
