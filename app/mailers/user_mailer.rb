class UserMailer < ActionMailer::Base
 	default from: "otter@nightzookeeper.com"

	def send_drawing
		mail(to: "otter@nightzookeeper.com", subject: "Otters are cool")
	end

end
