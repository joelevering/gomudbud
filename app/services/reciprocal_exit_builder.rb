# Given a room that was just saved, ensures a return exit exists on the
# other end of every exit whose "create the exit back" checkbox was ticked.
# Update-or-create by (target room, back to this room), so re-checking the
# box on a later save never creates a duplicate reciprocal.
class ReciprocalExitBuilder
  def self.call(room)
    room.exits.select(&:create_reciprocal?).each do |exit|
      target_room = Room.find_by(id: exit.linked_room_id)
      next unless target_room

      reciprocal = target_room.exits.find_or_initialize_by(linked_room_id: room.id)
      reciprocal.key = exit.reciprocal_key
      reciprocal.description = exit.reciprocal_description
      reciprocal.save!
    end
  end
end
