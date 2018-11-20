class Npc < ActiveRecord::Base
  belongs_to :room
  has_many :behaviors
  has_many :combat_behaviors
end
