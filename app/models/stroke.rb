class Stroke
  include Mongoid::Document

  field :colour
  field :opacity
  field :size
  field :eraser
  field :sample_points, type: Array

  embedded_in :drawing

  accepts_nested_attributes_for :sample_points
end
