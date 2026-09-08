# Given a room that was just saved, ensures a return exit exists on the
# other end of every exit whose "create the exit back" checkbox was ticked.
# Update-or-create by (target room, back to this room), so re-checking the
# box on a later save never creates a duplicate reciprocal.
#
# Returns an array of human-readable error messages for any reciprocal that
# failed to save (e.g. a key clash with an existing exit on the target room),
# rather than raising -- the room itself is already saved by the time this
# runs, so callers should surface these instead of letting a save! bubble up
# into a 500 on top of a change that already went through.
class ReciprocalExitBuilder
  def self.call(room)
    errors = []

    room.exits.select(&:create_reciprocal?).each do |exit|
      target_room = Room.find_by(id: exit.linked_room_id)
      next unless target_room

      reciprocal = target_room.exits.find_or_initialize_by(linked_room_id: room.id)
      reciprocal.key = exit.reciprocal_key
      reciprocal.description = exit.reciprocal_description

      unless reciprocal.save
        errors << "Couldn't create the exit back for \"#{exit.key}\" on ##{target_room.id} #{target_room.name}: #{reciprocal.errors.full_messages.to_sentence}"
      end
    end

    errors
  end
end
