class UnityPersonalChannel < ApplicationCable::Channel
	def subscribed
		stream_for current_user
	end

	# def receive(data)
	# 	ActionCable.server.broadcast(current_user, data)
	# end

	def getChatRooms
		broadcast(ChatRoom.all.pluck(:id, :name))
	end

	def getGuild
		broadcast(current_user.guild)
	end

	def getUnits
		units = Unit.find_by_guild(current_user.guild).pluck(:id, :name)		
		broadcast(units)
	end

	def getUnit(id)
		broadcast(Unit.find(id))
	end

	def setUnit(sent_unit)
		#use unit parameter to update unit in database
		#broadcast the updated unit (in case of failure or anything)
		unit = Unit.find(sent_unit["id"])
		result = unit.custom_update(sent_unit)

		broadcast(result)
	end

	def getMaps
		maps = current_user.guild.maps
		mapsHash = {}
		maps.each do |map|
			mapsHash[map.id] = map.name
		end

		broadcast(mapsHash)
	end

	def getMap(id)
		broadcast(Map.find(id))
	end

	def setMap(map)
		#use map parameter to update unit in database
		#broadcast the updated map (in case of failure or anything)
	end

	private
		def broadcast(response)
			ActionCable.server.broadcast(current_user, response)
		end
end