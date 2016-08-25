class Guild < ApplicationRecord
	belongs_to :user
	has_one :log

	has_many :guild_halls
	has_and_belongs_to_many :guild_abilities

	store_accessor :effects

	#Methods
	def self.new_user(user)
		guild = Guild.new
		guild.name = user.username + "'s Guild"
		guild.total_rep = 500
		guild.spent_rep = 0
		guild.money = 1000
		guild.effects = {}
		guild.user_id = user.id
		gravatar_id = Digest::MD5.hexdigest(guild.user.email.downcase)
		guild.avatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=24&d=identicon"

		guild.save
		hall = GuildHall.new_guild(guild)

		hall.save
		guild.save

		return guild
	end
end
