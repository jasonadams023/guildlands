class ChatMessagesChannel < ApplicationCable::Channel
	def subscribed
		chat_room = ChatRoom.find(params[:roomId])
		if chat_room.users.include?(current_user)
		# if true
			stream_from "chat_#{params[:roomId]}"
		end
	end

	def receive(data)
		data["username"] = current_user.username
		ActionCable.server.broadcast("chat_#{params[:roomId]}", data)
	end
end