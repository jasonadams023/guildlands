class MarketOrder < ApplicationRecord
  belongs_to :hall_inventory, dependent: :destroy
  belongs_to :item

  #Methods
  def npc_purchase (purchase_amount)
  	sale = 0
  	if self.amount > 0
	  	if self.amount - purchase_amount >= 0
	  		self.amount -= purchase_amount
	  		self.hall_inventory.total -= purchase_amount
	  		self.hall_inventory.selling -= purchase_amount

	  		sale = self.price * purchase_amount
	  	else
	  		self.amount -= self.amount
	  		self.hall_inventory.total -= self.amount
	  		self.hall_inventory.selling -= self.amount

	  		sale = self.price * self.amount
	  	end
	  	self.hall_inventory.guild_hall.guild.money += sale
	  	self.save
	  	self.hall_inventory.save
	  	self.hall_inventory.guild_hall.guild.save
  	end
  	return sale
  end
end