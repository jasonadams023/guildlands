class GuildAbility < ApplicationRecord
	has_and_belongs_to_many :guilds
end
