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
		if params[:return] == 'true'
			unit_inventory = UnitInventory.find(params[:id])
			amount = params[:unit_inventory][:amount].to_i

			unit_inventory.amount -= amount
			if unit_inventory.amount == 0 then unit_inventory.equipped = false end

			unit_inventory.hall_inventory.available += amount
			unit_inventory.hall_inventory.using -= amount

			if unit_inventory.save && unit_inventory.hall_inventory.save && unit_inventory.unit.save
				flash[:notice] = "Items moved back to Guild Hall."
			else
				flash[:alert] = "Failed to update."
			end
		end

		redirect_to unit_inventory.unit
	end

	private
		def unit_inventory_params
			params.require(:unit_inventory).permit(:unit_id, :hall_inventory_id, :amount, :equipped)
		end
end