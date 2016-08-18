class GuildHallsController < ApplicationController
	def index
	end

	def show
		@hall = GuildHall.find(params[:id])
	end

	def new
		@guild = current_user.guild
		@hall = GuildHall.new
	end

	def create
    	@hall = GuildHall.new(guild_hall_params)

		if @hall.save
			redirect_to current_user.guild
		else
			flash[:alert] = "Failed to create Guild Hall."
			@guild = current_user.guild
			@hall = GuildHall.new
			render :edit
		end
    end

	def edit
		@guild = current_user.guild
		@hall = GuildHall.new
	end

	def destroy
		hall = GuildHall.find(params[:id])
		guild = hall.guild

		if hall.delete
			if guild.save
				flash[:notice] = "Guild Hall destroyed."
			else
				flash[:alert] = "Guild was not updated."
			end
		else
			flash[:alert] = "Failed to destroy Guild Hall."
		end

		redirect_to guild_path(current_user.guild.id)
	end

	private
		def guild_hall_params
			params.require(:guild_hall).permit(:name, :size, :unit_limit, :effects, :guild_id, :location_id)
		end
end