class GuildAbilitiesController < ApplicationController
	def index
		@abilities = GuildAbility.all
		@guild = current_user.guild
	end

	def purchase
		ability = GuildAbility.find(params[:id])
		guild = current_user.guild
		rep = guild.total_rep - guild.spent_rep
		


		if rep >= ability.rep_cost
			guild.guild_abilities << ability
			guild.spent_rep += ability.rep_cost

			if guild.save
				flash[:notice] = "Ability purchased."
			else
				flash[:alert] = "Failed to purchase ability."
			end
		else
			flash[:alert] = "Not enough reputation to purchase ability."
		end

		redirect_to guild_path(guild)
	end

	def show
		@ability = GuildAbility.find(params[:id])
	end

	def new
	end

	def edit
	end

	def create
	end

	def destroy
	end
end
