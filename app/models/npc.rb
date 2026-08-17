class Npc < ApplicationRecord
  belongs_to :room
  has_many :behaviors
  has_many :combat_behaviors
end
