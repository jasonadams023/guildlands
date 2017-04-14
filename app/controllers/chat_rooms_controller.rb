class ChatRoomsController < ApplicationController
	def index
		@chat_rooms = ChatRoom.all
	end

	def show
		@chat_room = ChatRoom.find(params[:id])
		validate

		render layout: false
	end

	def new
		@chat_room = ChatRoom.new

		render layout: false
	end

	def edit
		@chat_room = ChatRoom.find(params[:id])
		if params[:join] = "true"
			@join = true
		else
			validate
		end
	end

	def create
		@chat_room = ChatRoom.new(chat_room_params)
		@chat_room.users.push(current_user)

		if @chat_room.save
			flash[:notice] = "Chat Room created succesfully."
			render @chat_room
		else
			flash[:alert] = "Failed to create Chat Room."
			render :new
		end
	end

	def update
		chat_room = ChatRoom.find(params[:id])

		if params[:chat_room][:try_password] != nil
			if params[:chat_room][:try_password] == chat_room.password
				chat_room.users.push(current_user)
			else
				flash[:alert] = "Incorrect password."
			end
		else
			chat_room.assign_attributes(chat_room_params)
		end

		if chat_room.save
			flash[:notice] = "Chat Room updated."
		else
			flash[:alert] = "Failed to update."
		end

		redirect_to chat_room
	end

	def destroy
		chat_room = ChatRoom.find(params[:id])

		if chat_room.destroy
			flash[:notice] = "Chat Room destroyed."
		else
			flash[:alert] = "Failed to destroy Chat Room."
		end

		redirect_to chat_rooms_path
	end

	private
		def validate
			if !@chat_room.users.include?(current_user)
				if @chat_room.password != ""
					redirect_to edit_chat_room_path, id: @chat_room.id, join: "true"
				else
					@chat_room.users.push(current_user)
				end
			end
		end

		def chat_room_params
			params.require(:chat_room).permit(:name, :password)
		end
end
