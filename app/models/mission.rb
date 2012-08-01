class Mission
  include Mongoid::Document
  
  field :name
  field :prompt
  field :confirmation
  field :date_created, type: Time, default: Time.now
  field :completed, type: Boolean, default: false
  field :date_completed, type: Time
  
  embedded_in :user
  embeds_one :template_drawing, class_name: 'Drawing', inverse_of: :mission_template
  embeds_one :result_drawing, class_name: 'Drawing', inverse_of: :mission_result

  def complete(curves, image)
  	self.completed = true
  	self.date_completed = Time.now
    self.result_drawing = Drawing.new({:curves => curves})
    self.result_drawing.from_base64(image)
    self.result_drawing.save
  end
end
