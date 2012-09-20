class Animal
  include Mongoid::Document

  field :name
  field :creator
  field :drawings, type: Array
  field :facts, type: Array
  field :mission_name
  field :mission_prompt
  field :story_title
  field :story
  field :levels, type: Array
end
