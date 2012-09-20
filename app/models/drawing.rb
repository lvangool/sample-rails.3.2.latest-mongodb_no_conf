require 'base64'

class Drawing
	include Mongoid::Document

	field :image_uid
	image_accessor :image
	field :date_created, type: Time, default: Time.now

  # Temp attribute whilst job is processing
  field :temp_image
  field :strokes, type: Array

	embeds_one :base_drawing, class_name: "Drawing", as: :drawable, cyclic: true

	embedded_in :drawable, polymorphic: true

  def self.process_drawing(user_id, drawing_id, base_id)
    user = User.find(user_id)
    
    if user.drawings.where(_id: drawing_id).exists?
      drawing = user.drawings.find(drawing_id)

      drawing.from_base64(drawing.temp_image)
      drawing.remove_attribute(:temp_image)
      drawing.base_drawing = user.drawings.find(base_id).dup if base_id
      drawing.save
    end
  end

  def self.process_mission(user_id, mission_id)
    user = User.find(user_id)
    mission = user.missions.find(mission_id)
    drawing = mission.completed_drawing

    drawing.from_base64(drawing.temp_image)
    drawing.remove_attribute(:temp_image)
    drawing.base_drawing = mission.template_drawing.dup if mission.template_drawing
    drawing.save
  end

	def from_base64(image_data)
		self.image = Base64.decode64(image_data)
		self.image.name = 'app_drawing.png'
	end

	def get_base64
		return  Base64.encode64(self.image.data)
	end
end