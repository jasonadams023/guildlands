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

	private
		def guild_hall_params
			params.require(:guild_hall).permit(:name, :size, :unit_limit, :effects, :guild_id, :location_id)
		end
end