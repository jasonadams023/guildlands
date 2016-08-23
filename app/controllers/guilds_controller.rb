class GuildsController < ApplicationController
	def index
	end
	
	def show
		@guild = current_user.guild
	end

	def new
	end

	def edit
		@guild = Guild.find(params[:id])
	end

	def update
		guild = Guild.find(params[:id])
		if guild.update(guild_params)
			flash[:notice] = "Guild updated."
		else
			flash[:alert] = "Failed to update Guild."
		end

		redirect_to guild
	end

	private
		def guild_params
			params.require(:guild).permit(:name, :avatar_url)
		end
end
