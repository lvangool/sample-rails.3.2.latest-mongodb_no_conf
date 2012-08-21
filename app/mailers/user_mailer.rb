class UserMailer < ActionMailer::Base
 	default from: "otter@nightzookeeper.com"

	def send_drawing(@user)
		mail(to: @user.email, subject: "Otters are cool")
	end

end
