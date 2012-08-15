class Stroke
  include Mongoid::Document

  field :colour
  field :opacity
  field :size
  field :eraser

  embedded_in :drawing
  embeds_many :sample_points, class_name: "Point", inverse_of: :strokes

  accepts_nested_attributes_for :sample_points
end
