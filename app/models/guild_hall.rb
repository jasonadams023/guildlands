class GuildHall < ApplicationRecord
  belongs_to :guild
  belongs_to :location

  has_many :rooms
  has_many :units
  has_one :hall_inventory
  has_many :items, through: :hall_inventory

  store_accessor :effects #can include unit limit, bonuses, etc.
end
