class ChatMessagesChannel < ApplicationCable::Channel
	def subscribed
		stream_from "chat_#{params[:roomId]}"
	end

	def receive(data)
		ActionCable.server.broadcast("chat_#{params[:roomId]}", data)
	end
end