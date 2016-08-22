module ApplicationHelper
	def avatar_url(user)
		if user_signed_in?
			gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
		else
			gravatar_id = Digest::MD5.hexdigest(user)
		end
			return "http://gravatar.com/avatar/#{gravatar_id}.png?s=24&d=identicon"

	end
end
