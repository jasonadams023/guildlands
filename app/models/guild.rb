class Guild < ApplicationRecord
	has_many :guild_halls
	has_many :units, through: :guild_halls
	has_and_belongs_to_many :guild_abilities

	store_accessor :effects
end
