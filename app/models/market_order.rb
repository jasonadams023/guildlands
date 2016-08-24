class MarketOrder < ApplicationRecord
  belongs_to :hall_inventory, dependent: :destroy
  belongs_to :item

  #Methods
  def npc_purchase (purchase_amount)
  	if self.amount > 0
	  	if self.amount - purchase_amount >= 0
	  		self.amount -= purchase_amount
	  		self.hall_inventory.total -= purchase_amount
	  		self.hall_inventory.selling -= purchase_amount
	  		self.hall_inventory.guild_hall.guild.money += self.price * purchase_amount
	  	else
	  		amount = self.amount
	  		self.amount -= amount
	  		self.hall_inventory.total -= amount
	  		self.hall_inventory.selling -= amount
	  		self.hall_inventory.guild_hall.guild.money += price * amount
	  	end
	  	self.save
	  	self.hall_inventory.save
	  	self.hall_inventory.guild_hall.guild.save
  	end
  end
end