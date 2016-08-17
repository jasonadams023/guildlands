class Location < ApplicationRecord
	store_accessor :effects #can include taxes, bonuses, resources, economy, etc.
end
