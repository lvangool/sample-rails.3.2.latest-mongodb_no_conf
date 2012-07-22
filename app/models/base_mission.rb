class BaseMission
  include Mongoid::Document

  field :name
  field :prompt
  field :date_created, type: Time, default: Time.now
end