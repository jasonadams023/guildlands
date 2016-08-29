class Guild < ApplicationRecord
	belongs_to :user
	has_many :logs

	has_many :guild_halls
	has_and_belongs_to_many :guild_abilities

	store_accessor :effects

	#Methods
	def set_effects
		self.guild_abilities.each do |ability|
			ability.effect.each do |key, effect|
				if self.effects[key] == nil
					self.effects[key] = effect
				else
					if key.include?('modifier')
			          self.effects[key] = self.effects[key].to_f * effect.to_f
			        else
			          self.effects[key] = self.effects.to_i + effect.to_i
			        end
				end
			end
		end
	end

	def reputation_change(reputation_change)
		max_rep = 10000
		if self.effects['rep_multiplier'] != nil
			reputation_change = reputations_change * self.effects['rep_multiplier'].to_i
		end

		if self.total_rep += reputation_change > max_rep
			self.total_rep = max_rep
		elsif self.total_rep += reputations_change < 0
			self.total_rep = 0
		else
			self.total_rep += reputation_change
		end
	end

	def money_change(money_change)
		max_money = 1000000
		if self.money += reputation_change > max_money
			self.money = max_money
		elsif self.money += reputations_change < 0
			self.money = 0
		else
			self.money += reputation_change
		end
	end

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
