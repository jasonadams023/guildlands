class UnitInventoriesController < ApplicationController
	def index
		@unit_inventories = UnitInventory.select{|inv| inv.unit_id == params[:unit_id].to_i && inv.amount > 0}
	end

	def show
		@unit_inventory = UnitInventory.find(params[:id])
	end

	def create
		unit_inventory = UnitInventory.new(unit_inventory_params)

		if unit_inventory.unit.unit_inventories.select{|inv| inv.hall_inventory.item_id == unit_inventory.hall_inventory.item_id}.length != 0
			unit_inventory = unit_inventory.unit.unit_inventories.select{|inv| inv.hall_inventory.item_id == unit_inventory.hall_inventory.item_id}[0]
			unit_inventory.amount += params[:unit_inventory][:amount].to_i
		end

		unit_inventory.hall_inventory.available -= params[:unit_inventory][:amount].to_i
		unit_inventory.hall_inventory.using += params[:unit_inventory][:amount].to_i

		if unit_inventory.save && unit_inventory.unit.save && unit_inventory.hall_inventory.save
			flash[:notice] = "Succesfully added items to unit inventory."
		else
			flash[:alert] = "Failed to update."
		end

		redirect_to unit_inventory.unit
	end

	def update
		unit_inventory = UnitInventory.find(params[:id])
		unit = unit_inventory.unit

		if params[:return] == 'true'
			amount = params[:unit_inventory][:amount].to_i

			unit_inventory.amount -= amount
			if unit_inventory.amount == 0 then unit_inventory.equipped = false end

			unit_inventory.hall_inventory.available += amount
			unit_inventory.hall_inventory.using -= amount

			if unit_inventory.save && unit_inventory.hall_inventory.save && unit.save
				flash[:notice] = "Items moved back to Guild Hall."
			else
				flash[:alert] = "Failed to update."
			end
		end

		if params[:use] == 'true'
			effects = unit_inventory.hall_inventory.item.effects

			if effects['xp'] != nil then unit.current_xp_change(effects['xp'].to_i) end
			if effects['hp'] != nil then unit.current_hp_change(effects['hp'].to_i) end
			if effects['sp'] != nil then unit.current_sp_change(effects['sp'].to_i) end

			unit_inventory.amount -= 1

			unit_inventory.hall_inventory.total -= 1
			unit_inventory.hall_inventory.using -= 1

			if unit_inventory.save && unit_inventory.hall_inventory.save && unit_inventory.unit.save
				flash[:notice] = "Succesfully used item."
			else
				flash[:alert] = "Failed to update."
			end
		end

		if params[:equip] != nil
			if params[:equip] == 'true'
				gear = unit.unit_inventories.select{|inv| inv.equipped == true}
				slot = unit_inventory.hall_inventory.item.effects['slot']

				gear.each do |equip|
					if equip.hall_inventory.item.effects['slot'] == slot then equip.equipped = false end
						equip.save
				end

				unit_inventory.equipped = true
			elsif params[:equip] == 'false'
				unit_inventory.equipped = false
			end
			unit_inventory.save
			unit_inventory.unit.save
			unit_inventory.unit.set_effects

			if unit_inventory.save && unit.save
				flash[:notice] = "Changed equipment."
			else
				flash[:alert] = "Failed to update."
			end
		end

		redirect_to unit
	end

	private
		def unit_inventory_params
			params.require(:unit_inventory).permit(:unit_id, :hall_inventory_id, :amount, :equipped)
		end
end