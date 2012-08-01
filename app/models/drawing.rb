require 'base64'

class Drawing
	include Mongoid::Document

	field :image_uid
  	image_accessor :image
  	field :curves
  	field :date_created, type: Time, default: Time.now
  
  	embedded_in :drawn, polymorphic: true # in user!
  	embedded_in :mission_drawable, polymorphic: true # in mission

  	def from_base64(image_data)
  		self.image = Base64.decode64(image_data)
  		self.image.name = 'app_drawing.png'
  	end
end