class UnityPersonalChannel < ApplicationCable::Channel
	def subscribed
		stream_from "user_#{current_user.id}"

		if current_user.auth = "admin"
			data = "admin"
			data_type = "auth"
			respond(data, data_type)
		end
	end

	# def receive(data)
	# 	ActionCable.server.broadcast(current_user, data)
	# end

	def getChatRooms
		data = ChatRoom.select(:id, :name)
		data_type = "chatRooms"
		respond(data, data_type)
	end

	def getGuild
		# data = current_user.guild
		# data_type = "guild"
		# respond(data, data_type)
		broadcast(current_user.guild)
	end

	def getUsername
		data = current_user.username
		data_type = "username"

		data = {username: data}

		respond(data, data_type)
	end

	def getUnits
		# data = Unit.find_by_guild(current_user.guild).select(:id, name)
		# data_type = "units"
		# respond(data, data_type)
		units = Unit.find_by_guild(current_user.guild).pluck(:id, :name)		
		broadcast(units)
	end

	def getUnit(id)
		# data = Unit.find(id)
		# data_type = "unit"
		# respond(data, data_type)
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
		data = Map.where("guild_id = ?", current_user.guild.id).select("id, name")
		data_type = "mapList"

		data = {list: data}

		respond(data, data_type)
	end

	def loadMap(data)
		#puts ("Inside loadMap")
		int_id = data["data"]

		if Map.exists?(int_id)
			data = Map.find(int_id)
		else
			data = "Failed to find Map."
		end

		data_type = "loadMap"

		respond(data, data_type)
	end

	def saveMap(data)
		puts("Start of setMap")
		unity_map = JSON.parse(data["data"])
		puts("map parsed")

		#guild = Guild.find(unity_map["guild_id"])
		guild = current_user.guild
		puts ("guild found")

		if Map.exists?(:guild_id => guild.id, :name => unity_map["name"])
			map = Map.find_by(:guild_id => guild.id, :name => unity_map["name"])
			puts ("Map exists")
		else
			map = Map.new
			puts ("Map does not exist")
		end

		map.guild_id = guild.id
		map.name = unity_map["name"]
		map.dimensions = unity_map["dimensions"]
		map.tile_types = unity_map["tile_types"]

		puts ("About to save map")

		if map.save
			puts("Map saved")
			output = "Map successfully saved."
		else
			puts("Map not saved")
			output = "Failed to save map."
		end

		puts ("returning output")
		respond(output, "saveResult")
		puts ("end of setMap")
	end

	private
		def broadcast(response)
			ActionCable.server.broadcast("user_#{current_user.id}", response)
		end

		def package_response(data, data_type)
			response = {data: data, details: {data_type: data_type}}
		end

		def respond (data, data_type)
			response = package_response(data, data_type)
			broadcast(response)
		end
end