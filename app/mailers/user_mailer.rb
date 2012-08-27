class UserMailer < ActionMailer::Base
 	default from: "otter@nightzookeeper.com"

	def send_drawing(user_id)
		@user = User.find(user_id)

		mail(to: @user.email, subject: "Your Night Zookeeper Drawing")
	end
end
