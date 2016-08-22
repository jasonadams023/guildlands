# Used to customize Devise
class RegistrationsController < Devise::RegistrationsController
	def create
		super do |resource|
			if resource.save
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
