# Loads a GoMud rooms.json-shaped array into the database (full replace).
# Counterpart to RoomExport -- together they should round-trip losslessly.
class RoomImport
  Result = Struct.new(:rooms, :npcs, :exits, :behaviors, :combat_behaviors, keyword_init: true)

  class ValidationError < StandardError; end

  def self.call(data)
    validate!(data)

    counts = { npcs: 0, exits: 0, behaviors: 0, combat_behaviors: 0 }

    ActiveRecord::Base.transaction do
      BehaviorAction.delete_all
      CombatBehavior.delete_all
      Behavior.delete_all
      Exit.delete_all
      Npc.delete_all
      Room.delete_all

      # Rooms are created before exits/npcs so forward references between
      # rooms (very common -- room 1 usually exits to a higher room id
      # defined later in the array) resolve correctly.
      data.each do |r|
        Room.create!(id: r["id"], name: r["name"], description: r["description"])
      end

      data.each do |r|
        room = Room.find(r["id"])
        import_exits(room, r["exits"] || [], counts)
        import_npcs(room, r["npcs"] || [], counts)
      end
    end

    Result.new(rooms: data.size, **counts)
  end

  def self.import_exits(room, exits, counts)
    exits.each do |e|
      room.exits.create!(linked_room_id: e["room_id"], key: e["key"], description: e["description"])
      counts[:exits] += 1
    end
  end
  private_class_method :import_exits

  def self.import_npcs(room, npcs, counts)
    npcs.each do |n|
      char = n["character"] || {}
      npc = room.npcs.create!(
        id: n["id"],
        name: char["name"],
        description: n["description"],
        class_name: n["class"],
        level: char["level"],
        exp: char["exp_given"]
      )
      counts[:npcs] += 1

      (n["behavior"] || []).each do |b|
        behavior = npc.behaviors.create!(trigger: b["trigger"], chance: b["chance"])
        (b["actions"] || []).each { |action| behavior.actions.create!(action: action[0], payload: action[1]) }
        counts[:behaviors] += 1
      end

      (n["combat_behavior"] || []).each do |cb|
        npc.combat_behaviors.create!(skill_name: cb["skill"], chance: cb["chance"])
        counts[:combat_behaviors] += 1
      end
    end
  end
  private_class_method :import_npcs

  def self.validate!(data)
    raise ValidationError, "expected the JSON root to be an array of rooms" unless data.is_a?(Array)

    problems = []

    room_ids = data.map { |r| r["id"] }
    dupe_room_ids = room_ids.tally.select { |_, count| count > 1 }.keys
    problems << "duplicate room ids: #{dupe_room_ids.sort}" if dupe_room_ids.any?

    room_id_set = room_ids.to_set
    dangling = []
    data.each do |r|
      (r["exits"] || []).each do |e|
        dangling << [ r["id"], e["room_id"] ] unless room_id_set.include?(e["room_id"])
      end
    end
    problems << "dangling exit targets (from_room -> missing_target): #{dangling}" if dangling.any?

    npc_ids = data.flat_map { |r| (r["npcs"] || []).map { |n| n["id"] } }
    dupe_npc_ids = npc_ids.tally.select { |_, count| count > 1 }.keys
    problems << "duplicate npc ids: #{dupe_npc_ids.sort}" if dupe_npc_ids.any?

    raise ValidationError, problems.join("; ") if problems.any?
  end
end
