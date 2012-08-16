class Mission
  include Mongoid::Document
  
  field :name
  field :prompt
  field :confirmation
  field :date_created, type: Time, default: Time.now
  field :completed, type: Boolean, default: false
  field :date_completed, type: Time
  
  embedded_in :user
  embeds_one :template_drawing, class_name: "Drawing", as: :drawable
  embeds_one :completed_drawing, class_name: "Drawing", as: :drawable

  def complete(curves, image)
  	self.completed = true
  	self.date_completed = Time.now
    drawing = self.completed_drawing.build

    drawing.strokes_attributes = JSON.parse(curves.to_s)

    if !self.template_drawing.nil?
      drawing.base_drawing = self.template_drawing.dup
    end
    
    drawing.from_base64(image)
    drawing.save
  end
end
