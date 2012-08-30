class Mission
  include Mongoid::Document
  
  field :name
  field :prompt
  field :confirmation
  field :date_created, type: Time, default: Time.now
  field :completed, type: Boolean, default: false
  field :date_completed, type: Time
  field :tools, type: Array
  
  embedded_in :user
  embeds_one :template_drawing, class_name: "Drawing", as: :drawable
  embeds_one :completed_drawing, class_name: "Drawing", as: :drawable

  accepts_nested_attributes_for :completed_drawing
end
