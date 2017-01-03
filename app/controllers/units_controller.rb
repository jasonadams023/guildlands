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
		@activities = nil
		if @unit.guild_hall_id == nil
			@free = true
		else
			@free = false
			@activities = @unit.return_activities
		end

		@unit.set_effects
		@unit.save
	end

	def new
		@guild = current_user.guild
		@unit = Unit.new
	end

	def edit
		@unit = Unit.find(params[:id])
		@guild = @unit.guild_hall.guild
		if params[:name] == 'true' then @name = true end
		if params[:train] == 'true' then @train = true end
	end

	def create
		if !check_complete
			flash[:alert] = "Failed to save unit."
			@guild = current_user.guild
			@unit = Unit.new and return
		else
			@unit = Unit.new(unit_params)
			@unit.custom_new
			guild = @unit.guild_hall.guild

			xp = @unit.calc_spent_xp
			if xp <= @unit.total_xp
				if @unit.total_xp <= guild.total_rep
					cost = xp + @unit.total_xp
					if guild.money >= cost
						@unit.spent_xp = xp
						guild.money -= cost

						if @unit.save && guild.save
							flash[:notice] = "Created new unit."
							redirect_to current_user.guild and return
						else
							flash[:alert] = "Failed to save unit."
						end
					else
						flash[:alert] = "Guild does not have enough money to hire this unit."
					end
				else
					flash[:alert] = "Guild does not have enough reputation to hire this unit."
				end
			else
				flash[:alert] = "Spent xp exceeds total xp."
			end
		end
		@guild = current_user.guild
		@unit = Unit.new
		render :new
	end

	def update
		unit = Unit.find(params[:id])
		guild = unit.guild_hall.guild
		cost = 0
		compare_unit = Unit.new

		compare_unit.assign_attributes(unit_params)

		if compare_unit.strength != nil
			if compare_unit.strength > unit.strength
				cost += compare_unit.calc_xp_per_stat(compare_unit.strength) - unit.calc_xp_per_stat(unit.strength)
			end
		end
		if compare_unit.agility != nil
			if compare_unit.agility > unit.agility
				cost += compare_unit.calc_xp_per_stat(compare_unit.agility) - unit.calc_xp_per_stat(unit.agility)
			end
		end
		if compare_unit.vitality != nil
			if compare_unit.vitality > unit.vitality
				cost += compare_unit.calc_xp_per_stat(compare_unit.vitality) - unit.calc_xp_per_stat(unit.vitality)
			end
		end
		if compare_unit.stamina != nil
			if compare_unit.stamina > unit.stamina
				cost += compare_unit.calc_xp_per_stat(compare_unit.stamina) - unit.calc_xp_per_stat(unit.stamina)
			end
		end
		if compare_unit.intelligence != nil
			if compare_unit.intelligence > unit.intelligence
				cost += compare_unit.calc_xp_per_stat(compare_unit.intelligence) - unit.calc_xp_per_stat(unit.intelligence)
			end
		end
		if compare_unit.focus != nil
			if compare_unit.focus > unit.focus
				cost += compare_unit.calc_xp_per_stat(compare_unit.focus) - unit.calc_xp_per_stat(unit.focus)
			end
		end

		previous_discount = unit.calc_xp_discount
		unit.assign_attributes(unit_params)
		discount = unit.calc_xp_discount - previous_discount
		cost -= discount

		if discount < 0 then discount = 0 end
		test_xp = unit.calc_spent_xp

		if test_xp <= unit.total_xp
			if test_xp > unit.spent_xp then cost = test_xp - unit.spent_xp else cost = 0 end

			if guild.money >= cost
				guild.money -= cost

				unit.set_effects
				unit.spent_xp = test_xp

				if unit.save && guild.save
					flash[:notice] = "Unit updated."
				else
					flash[:alert] = "Failed to update."
				end
			else
				flash[:alert] = "Guild does not have enough money to train this unit."
			end
		else
			flash[:alert] = "Spent xp would exceed total xp."
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
				return false
			else
				return true
			end
		end
end