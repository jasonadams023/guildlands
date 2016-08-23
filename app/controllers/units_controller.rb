class UnitsController < ApplicationController
	def index
		if params[:guild_id] == nil && params[:guild_hall_id] == nil
			@units = Unit.all.select{|u| u.guild_hall_id == nil}
		elsif params[:guild_id] != nil
			guild = Guild.find(params[:guild_id].to_i)
			halls = guild.guild_halls
			@units = []
			halls.each do |hall|
				hall.units.each do |unit|
					@units << unit
				end
			end
		else
			guild_hall = GuildHall.find(params[:guild_hall_id].to_i)
			@units = guild_hall.units
		end
	end

	def show
		@unit = Unit.find(params[:id])
		@free = nil
		if @unit.guild_hall_id == nil
			@free = true
		else
			@free = false
		end
	end

	def new
		@guild = current_user.guild
		@unit = Unit.new
	end

	def edit
		@unit = Unit.find(params[:id])
		@guild = @unit.guild_hall.guild
	end

	def create
		check_complete
		@unit.custom_new
		guild = @unit.guild_hall.guild

		if guild.money >= @unit.hiring_cost
			guild.money -= @unit.hiring_cost

			if @unit.save && guild.save
				flash[:notice] = "Created new unit."
				redirect_to current_user.guild and return
			else
				flash[:alert] = "Failed to save unit."
			end
		else
			flash[:alert] = "Guild does not have enough money to hire this unit."
		end
		@guild = current_user.guild
		@unit = Unit.new
		render :edit
	end

	def update
		unit = Unit.find(params[:id])
		guild = unit.guild_hall.guild
		cost = 0

		strength = params[:unit][:strength].to_i
		agility = params[:unit][:agility].to_i
		vitality = params[:unit][:vitality].to_i
		stamina = params[:unit][:stamina].to_i
		intelligence = params[:unit][:intelligence].to_i
		focus = params[:unit][:focus].to_i

		if strength> unit.strength then cost += ((strength - unit.strength) * 100) end
		if agility > unit.agility then cost += ((strength - unit.strength) * 100) end
		if vitality > unit.vitality then cost += ((strength - unit.strength) * 100) end
		if stamina > unit.stamina then cost += ((strength - unit.strength) * 100) end
		if intelligence > unit.intelligence then cost += ((strength - unit.strength) * 100) end
		if focus > unit.focus then cost += ((strength - unit.strength) * 100) end

		if guild.money >= cost
			guild.money -= cost
			if unit.update(unit_params) && guild.save
				flash[:notice] = "Unit updated."
			else
				flash[:alert] = "Failed to update."
			end
		else
			flash[:alert] = "Guild does not have enough money to train this unit."
		end

		redirect_to unit
	end

	def purchase
		unit = Unit.find(params[:id])

		if GuildHall.find(params[:unit][:guild_hall_id]) != ''
		hall = GuildHall.find(params[:unit][:guild_hall_id])

			if hall.units.length < hall.unit_limit
				if hall.guild.money >= unit.hiring_cost
					hall.units << unit
					hall.guild.money -= unit.hiring_cost
					if unit.save && hall.save && hall.guild.save
						flash[:notice] = "Unit Hired."
						
					else
						flash[:alert] = "Failed to update."
					end
				else
					flash[:alert] = "Guild does not have enough money to hire this unit."
				end
			else
				flash[:alert] = "That Guild Hall cannot hold any more units."
			end
		else
			flash[:alert] = "No Guild Hall specified."
		end

		redirect_to unit_path(unit)
	end

	def release
		unit = Unit.find(params[:id])
		hall = unit.guild_hall

		hall.units.delete(unit)
		
		if unit.save
			flash[:notice] = "Unit released."
		else
			flash[:alert] = "Failed to release unit."
		end

		redirect_to guild_path(current_user.guild.id)
	end

	def destroy
		unit = Unit.find(params[:id])
		hall = unit.guild_hall

		hall.units.destroy(unit)
		
		if hall.save
			flash[:notice] = "Unit deleted."
		else
			flash[:alert] = "Failed to delete unit."
		end

		redirect_to guild_path(current_user.guild.id)
	end

	private
		def unit_params
			params.require(:unit).permit(:name, :total_xp, :guild_hall_id,
                                        :strength, :agility, :vitality,
                                        :stamina, :intelligence, :focus,
                                        :activity_id)
		end

		def increase_stats (unit, strength, agility, vitality, stamina, intelligence, focus)
			if strength > unit.strength || agility >> unit.agility || vitality > unit.vitality || stamina > unit.stamina || intelligence > unit.intelligence || focus > unit.focus
				true
			else
				false
			end
		end

		def check_complete
			@unit = Unit.new(unit_params)
			if @unit.name == '' || @unit.total_xp == nil || @unit.guild_hall_id == nil || @unit.strength == nil || @unit.agility == nil || @unit.vitality == nil || @unit.stamina == nil || @unit.intelligence == nil || @unit.focus == nil
				flash[:alert] = "Failed to save unit."
				@guild = current_user.guild
				@unit = Unit.new
				render :edit
			end
		end
end