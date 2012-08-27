class Point
  include Mongoid::Document

  field :x
  field :y

  embedded_in :stroke
end
