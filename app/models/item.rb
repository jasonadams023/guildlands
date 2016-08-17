class Item < ApplicationRecord
	has_many :hall_inventories
	has_many :guild_halls, through: :hall_inventories
end
