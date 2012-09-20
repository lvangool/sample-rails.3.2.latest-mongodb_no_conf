class Drawing
	include Mongoid::Document

	field :image
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

      drawing.image = Cloudinary::Uploader.upload(drawing.temp_image, :tags => [user._id.to_s+"_thumbs"])

      drawing.remove_attribute(:temp_image)
      drawing.base_drawing = user.drawings.find(base_id).dup if base_id
      drawing.save
    end
  end

  def self.process_mission(user_id, mission_id)
    user = User.find(user_id)
    mission = user.missions.find(mission_id)
    drawing = mission.completed_drawing

   	drawing.image = Cloudinary::Uploader.upload(drawing.temp_image)
    drawing.remove_attribute(:temp_image)
    drawing.base_drawing = mission.template_drawing.dup if mission.template_drawing
    drawing.save
  end

  def get_url(width = nil, height = nil)
    if width.nil? && height.nil?
      return self.image['url']
    else
      options = {
        :format => self.image['format'], 
        :version => drawing.image['version'], 
        :crop => :scale
      }

      options.width = width unless width.nil?
      options.height = height unless height.nil?

      return Cloudinary::Utils.cloudinary_url(self.image['public_id'], options)
    end
  end
end