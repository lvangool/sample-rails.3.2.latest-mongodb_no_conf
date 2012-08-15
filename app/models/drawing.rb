require 'base64'

class Drawing
	include Mongoid::Document

	field :image_uid
	image_accessor :image
	field :date_created, type: Time, default: Time.now

  # Temp attribute whilst job is processing
  field :temp_strokes
  field :temp_image

	embeds_one :base_drawing, class_name: "Drawing", as: :drawable, cyclic: true

	embedded_in :drawable, polymorphic: true
  embeds_many :strokes

  accepts_nested_attributes_for :strokes

	def from_base64(image_data)
		self.image = Base64.decode64(image_data)
		self.image.name = 'app_drawing.png'
	end

  def upload_image
    self.from_base64(self.temp_image)
    self.remove_attribute(:temp_image)
  end

	def get_base64
		return  Base64.encode64(self.image.data)
	end

	def add_parent(base_id)
		self.base_drawing = self.user.drawings.find(base_id).dup
	end
end