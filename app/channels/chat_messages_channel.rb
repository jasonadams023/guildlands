class ChatMessagesChannel < ApplicationCable::Channel
	def subscribed
		stream_from 'chat_messages'
	end
end