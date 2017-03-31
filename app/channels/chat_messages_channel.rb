class ChatMessagesChannel < ApplicationCable::Channel
	def subscribed
		stream from 'chat_messages'
	end
end