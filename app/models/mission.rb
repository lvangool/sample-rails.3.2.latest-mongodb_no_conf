class Mission
  include Mongoid::Document
  
  field :name
  field :prompt
  field :date_created, type: Time, default: Time.now
  field :completed, type: Boolean, default: false
  field :date_completed, type: Time
  
  embedded_in :user

  def complete
  	self.completed = true
  	self.date_completed = Time.now
  end
end
