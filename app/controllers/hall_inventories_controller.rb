class HallInventoriesController < ApplicationController
	def index
		if params[:guild_hall_id] != ''
			hall = GuildHall.find(params[:guild_hall_id].to_i)
			@inventories = hall.hall_inventories
		elsif params[:guild_id] != ''
			guild = Guild.find(params[:guild_id])
			@inventories = []
			guild.guild_halls.each do |hall|
				hall.hall_inventories.each do |inventory|
					@inventories << inventory
				end
			end
		else
			@inventories = HallInventory.all
		end
	end

	def show
		@inventory = HallInventory.find(params[:id])
		@order = MarketOrder.new
	end

	def new
	end

	def edit
	end

	def update
		inventory = HallInventory.find(params[:id])
		

		if params[:move] == 'true'
			if params[:hall_inventory][:guild_hall_id] != '' && params[:hall_inventory][:available] != ''
				hall = GuildHall.find(params[:hall_inventory][:guild_hall_id])
				amount = params[:hall_inventory][:available].to_i
				if !(hall.items.include?(inventory.item)) #If inventory does not exist in target hall
					hall.items << inventory.item #Initialize new inventory
					id = hall.hall_inventories.find_index{|i| inventory.item_id == i.item_id}
					hall.hall_inventories[id].total = 0
					hall.hall_inventories[id].available = 0
					hall.hall_inventories[id].selling = 0 #/Initialize new inventory
				else
					id = hall.hall_inventories.find_index{|i| inventory.item_id == i.item_id}
				end
				
				hall.hall_inventories[id].total += amount #update target hall
				hall.hall_inventories[id].available += amount

				inventory.total -= amount #update origin hall
				inventory.available -= amount

				if inventory.save && hall.save && hall.hall_inventories[id].save
					flash[:notice] = "Succesfully moved items."
				else
					flash[:alert] = "Failed to update."
				end
			else
				flash[:alert] = "Form not completed."
			end
		end

		redirect_to inventory
	end

	def create
	end

	def purchase
	end

	def release
	end

	def destroy
	end

	private
end
