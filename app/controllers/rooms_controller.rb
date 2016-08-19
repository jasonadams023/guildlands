class RoomsController < ApplicationController
	def index
		@rooms = Room.all
		if params[:guild_hall_id] != nil then @hall = params[:guild_hall_id].to_i else @hall = nil end
	end

	def show
	end

	def new
	end

	def edit
	end

	def create
	end

	def purchase
		room = Room.find(params[:id])
		hall = GuildHall.find(params[:guild_hall_id])

		if (hall.rooms.sum(&:size) + room.size) < hall.size
			if hall.guild.money >= room.cost
				hall.rooms << room
				hall.guild.money -= room.cost
				if hall.save && hall.guild.save
					flash[:notice] = "Room purchased."
				else
					flash[:alert] = "Failed to update Guild Hall."
				end
			else
				flash[:alert] = "Guild does not have enough money to purchase this room."
			end
		else
			flash[:alert] = "This Guild Hall does not have enough space for this room."
		end

		redirect_to hall
	end

	def release
		id = params[:id].to_i 
		hall = GuildHall.find(params[:guild_hall_id])

		if hall.room_inventories.destroy(id)
			if hall.save
				flash[:notice] = "Demolished room."
			else
				flash[:alert] = "Failed to update Guild Hall."
			end
		else
			flash[:alert] = "Failed to destroy room."
		end

		redirect_to hall
	end

	def destroy
	end

	private
end
