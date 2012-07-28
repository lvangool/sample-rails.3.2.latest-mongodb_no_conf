require 'base64'

class Drawing
	include Mongoid::Document

	field :image_uid
  	image_accessor :image
  	field :curves
  
  	embedded_in :user

  	def from_base64(image_data, user)
  		self.image = Base64.decode64(image_data)
  		self.user = user
  	end
end