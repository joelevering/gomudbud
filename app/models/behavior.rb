class Behavior < ActiveRecord::Base
  POSSIBLE_TRIGGERS = [
    "pc-enters",
    "pc-leaves"
  ]

  belongs_to :npc
  has_many :actions, class_name: "BehaviorAction"

  validates_inclusion_of :trigger, in: POSSIBLE_TRIGGERS
end
