class GuildHallsController < ApplicationController
	def index
		if params[:guild_id] != nil then guild_id = params[:guild_id].to_i else guild_id = nil end
		@halls = GuildHall.all.select{|hall| hall.guild_id == guild_id}
	end

	def show
		@hall = GuildHall.find(params[:id])
		@used_space = calc_used_space(@hall)
		@value = calc_value(@hall)
		@total_upkeep = calc_total_upkeep(@hall)

		@free = nil
		if @hall.guild_id == nil
			@free = true
		else
			@free = false
		end
	end

	def new
		@guild = current_user.guild
		@hall = GuildHall.new
	end

	def edit
		@hall = GuildHall.find(params[:id])
	end

	def create
    	@hall = GuildHall.new(guild_hall_params)
    	@hall.rooms << Room.find(1)#basic bedroom
    	value = calc_value(@hall)

    	if @hall.guild.money >= value
    		@hall.guild.money -= value
    		@hall.effects = {}
	    	@hall.set_unit_limit
	    	@hall.set_effects

			if @hall.save && @hall.guild.save
				flash[:notice] = "Guild Hall created."
				redirect_to current_user.guild and return
			else
				flash[:alert] = "Failed to create Guild Hall."
			end
		else
			flash[:alert] = "Guild does not have enough money to build this Guild Hall."
		end
		@guild = current_user.guild
		@hall = GuildHall.new
		render :edit
    end

    def update
    	hall = GuildHall.find(params[:id])

    	if hall.update(guild_hall_params)
    		hall.set_effects
    		flash[:notice] = "Guild Hall updated."
    	else
    		flash[:alert] = "Failed to update Guild Hall."
    	end

    	redirect_to hall
    end

    def purchase
    	@hall = GuildHall.find(params[:id])
    	guild = current_user.guild

    	if guild.money >= calc_value(@hall)
    		guild.guild_halls << @hall
    		guild.money -= calc_value(@hall)

    		if guild.save && @hall.save
    			flash[:notice] = "Guild Hall purchased."
    		else
    			flash[:alert] = "Failed to update."
    		end
    	else
    		flash[:alert] = "Guild does not have enough money to purchase this Guild Hall."
    	end

    	redirect_to guild_hall_path(@hall)
    end

	def release
		@hall = GuildHall.find(params[:id])
		guild = current_user.guild

		if guild.guild_halls.delete(@hall)
			guild.money += calc_value(@hall) / 2
			if @hall.save && guild.save
				flash[:notice] = "Guild Hall sold."
			else
				flash[:alert] = "Hall was not updated."
			end
		else
			flash[:alert] = "Failed to release Guild Hall."
		end

		redirect_to guild_path(current_user.guild.id)
	end

	def destroy
		hall = GuildHall.find(params[:id])
		guild = hall.guild
		rooms = hall.rooms

		hall.hall_inventories.destroy_all
		hall.rooms.delete(rooms)
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

		def calc_used_space(hall)
			arr = hall.rooms.map {|room| room.size}
			result = 0

			arr.each do |i|
				result += i
			end

			return result
		end

		def calc_value(hall)
			value = 0
			value += @hall.size * 100
			hall.rooms.map{|room| value += room.cost}

			return value
		end

		def calc_total_upkeep(hall)
			total = 0
			hall.units.each do |unit|
				total += unit.upkeep_cost
			end

			return total
		end
end