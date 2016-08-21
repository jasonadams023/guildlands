class Location < ApplicationRecord
	has_many :activities
	has_many :guild_halls
	
	store_accessor :effects #can include taxes, bonuses, resources, economy, etc.
end
