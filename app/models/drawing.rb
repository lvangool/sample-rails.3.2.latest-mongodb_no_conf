require 'base64'

class Drawing
	include Mongoid::Document

	field :image_uid
  	image_accessor :image
  
  	embedded_in :user

  	def from_base64(image_data, user)
  		self.image = Base64.decode64(image_data.sub("data:image/png;base64,", ""))
  		self.user = user
  	end
end