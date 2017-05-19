class UnityMatchChannel < ApplicationCable::Channel
	def subscribed
		stream_from "match_#{params[:matchId]}"
	end

	private
		def broadcast(response)
			ActionCable.server.broadcast("match_#{params[:matchId]}", response)
		end
end