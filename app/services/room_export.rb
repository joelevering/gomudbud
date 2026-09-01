# Composes the DB into the exact JSON shape GoMud's room.LoadRooms expects.
class RoomExport
  def self.call
    Room.order(:id).map { |room| export_room(room) }
  end

  def self.export_room(room)
    out = { "id" => room.id, "name" => room.name, "description" => room.description }
    out["exits"] = room.exits.order(:id).map { |e| export_exit(e) }
    npcs = room.npcs.order(:id).map { |n| export_npc(n) }
    out["npcs"] = npcs if npcs.any?
    out
  end

  def self.export_exit(exit)
    { "room_id" => exit.linked_room_id, "key" => exit.key, "description" => exit.description }
  end

  def self.export_npc(npc)
    out = { "id" => npc.id }
    out["description"] = npc.description if npc.description.present?
    out["class"] = npc.class_name
    out["character"] = { "name" => npc.name, "level" => npc.level, "exp_given" => npc.exp }

    behavior = npc.behaviors.order(:id).map { |b| export_behavior(b) }
    out["behavior"] = behavior if behavior.any?

    combat_behavior = npc.combat_behaviors.order(:id).map { |cb| export_combat_behavior(cb) }
    out["combat_behavior"] = combat_behavior if combat_behavior.any?

    out
  end

  def self.export_behavior(behavior)
    {
      "trigger" => behavior.trigger,
      "actions" => behavior.actions.order(:id).map { |a| [ a.action, a.payload ] },
      "chance" => behavior.chance
    }
  end

  def self.export_combat_behavior(cb)
    { "skill" => cb.skill_name, "chance" => cb.chance }
  end
end
