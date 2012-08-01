class Mission
  include Mongoid::Document
  
  field :name
  field :prompt
  field :confirmation
  field :date_created, type: Time, default: Time.now
  field :completed, type: Boolean, default: false
  field :date_completed, type: Time
  
  embedded_in :user
  embeds_one :template, class_name: 'Drawing', as: :mission_drawable
  embeds_one :result, class_name: 'Drawing', as: :mission_drawable

  def complete(curves, image)
  	self.completed = true
  	self.date_completed = Time.now
    self.drawing = Drawing.new({:curves => curves})
    self.drawing.from_base64(image)
  end
end
