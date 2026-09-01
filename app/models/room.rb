class Room < ApplicationRecord
  has_many :exits, dependent: :destroy
  has_many :npcs, dependent: :destroy

  accepts_nested_attributes_for :exits, :npcs, allow_destroy: true

  def area
    name.to_s.split(" - ").first.to_s.strip.presence || "Unsorted"
  end
end
