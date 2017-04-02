class ChatMessagesController < ApplicationController
	def create
		chat_message = ChatMessage.new(chat_message_params)
	    chat_message.user = current_user

	    if chat_message.save
	    	ActionCable.server.broadcast 'chat_messages',
	    		content: chat_message.content,
	    		username: chat_message.user.username
	    	head :ok
	    else
	    	flash[:alert] = "Failed to save Chat Message."
	    end
	end

	def destroy
	end

	private
		def chat_message_params
			params.require(:chat_message).permit(:content, :chat_room_id)
		end
end
