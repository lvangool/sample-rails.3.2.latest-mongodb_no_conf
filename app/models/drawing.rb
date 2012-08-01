require 'base64'

class Drawing
	include Mongoid::Document

	field :image_uid
  	image_accessor :image
  	field :curves
  	field :date_created, type: Time, default: Time.now
  
  	embedded_in :user
  	embedded_in :mission_template, class_name: 'Mission', inverse_of: :template_drawing
  	embedded_in :mission_result, class_name: 'Mission', inverse_of: :result_drawing

  	def from_base64(image_data)
  		self.image = Base64.decode64(image_data)
  		self.image.name = 'app_drawing.png'
  	end

  	def get_base64
  		return  Base64.encode64(self.image.data)
  	end
end