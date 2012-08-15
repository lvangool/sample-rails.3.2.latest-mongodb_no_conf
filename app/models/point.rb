class Point
  include Mongoid::Document

  field :sample, type: Hash
  field :handle, type: Hash

  embedded_in :stroke
end
