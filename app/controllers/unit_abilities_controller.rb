class UnitAbilitiesController < ApplicationController
	def index
		@abilities = UnitAbility.all
		if params[:unit_id] != nil then @unit = Unit.find(params[:unit_id]) end
	end

	def show
		@ability = UnitAbility.find(params[:id])
		if params[:unit_id] != nil then @unit = Unit.find(params[:unit_id]) end
	end

	def new
	end

	def edit
	end

	def purchase
		ability = UnitAbility.find(params[:id])
		unit = Unit.find(params[:unit_id])
		guild = unit.guild_hall.guild

		if (unit.total_xp - unit.spent_xp) >= ability.xp_cost
			if guild.money >= ability.xp_cost
				unit.unit_abilities << ability
				unit.spent_xp += ability.xp_cost

				guild.money -= ability.xp_cost

				if unit.save && guild.save
					flash[:notice] = "Ability training purchased."
				else
					flash[:alert] = "Failed to update."
				end
			else
				flash[:alert] = "Guild does not have enough money to train this ability."
			end
		else
			flash[:alert] = "This unit does not have enough experience available to train this ability."
		end

		redirect_to unit		
	end

	def release
		ability = UnitAbility.find(params[:id])
		unit = Unit.find(params[:unit_id])
		id = unit.unit_abilities.find_index{|a| a.id == ability.id}

		if unit.unit_abilities.delete(ability)
			unit.spent_xp -= ability.xp_cost
			if unit.save
				flash[:notice] = "Ability untrained."
			else
				flash[:alert] = "Failed to update."
			end
		else
			flash[:alert] = "Failed to remove ability."
		end

		redirect_to unit
	end

	def destroy
	end
end
