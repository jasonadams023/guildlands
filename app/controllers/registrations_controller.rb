# Used to customize Devise
class RegistrationsController < Devise::RegistrationsController
	def create
		super do |resource|
			if resource.save
				gravatar_id = Digest::MD5.hexdigest(resource.email.downcase)
				resource.avatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=24&d=identicon"
				guild = Guild.new_user(resource)
				guild.save
				resource.save
			end
		end
	end

	private
        def sign_up_params
            params.require(:user).permit(:username, :email, :password, :password_confirmation)
        end
end
