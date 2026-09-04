class Npc < ApplicationRecord
  belongs_to :room
  has_many :behaviors, dependent: :destroy
  has_many :combat_behaviors, dependent: :destroy

  accepts_nested_attributes_for :behaviors, :combat_behaviors, allow_destroy: true
end
