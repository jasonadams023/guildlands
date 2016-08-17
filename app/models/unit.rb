class Unit < ApplicationRecord
  belongs_to :guild
  belongs_to :guild_hall
  belongs_to :location
  belongs_to :activity

  has_one :unit_inventory
  has_many :items, through: :unit_inventory

  has_and_belongs_to_many :unit_abilities
end
