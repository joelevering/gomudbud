class Behavior < ActiveRecord::Base
  belongs_to :npc
  has_many :actions, class_name: "BehaviorAction"
end
