class Exit < ApplicationRecord
  belongs_to :room
  # belongs_to_required_by_default (on since Rails 5) already validates that
  # linked_room_id both is present and resolves to a real Room -- no extra
  # validation needed for that half of issue #3.
  belongs_to :linked_room, class_name: "Room"

  validates :key, uniqueness: { scope: :room_id, case_sensitive: false, message: "is already used by another exit from this room" }

  # Non-persisted: driven by the "create the exit back" checkbox in the room
  # form. See ReciprocalExitBuilder, which reads these after the room saves.
  attr_accessor :create_reciprocal, :reciprocal_key, :reciprocal_description

  def create_reciprocal?
    ActiveModel::Type::Boolean.new.cast(create_reciprocal)
  end
end
