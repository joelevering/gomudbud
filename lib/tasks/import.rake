desc "Import a GoMud rooms.json file into the database (full replace)"
task :import_rooms, [ :path ] => :environment do |_t, args|
  path = args[:path] || File.expand_path("../gomud/data/rooms.json", Rails.root)

  unless File.exist?(path)
    abort "No file at #{path}"
  end

  data = JSON.parse(File.read(path))
  unless data.is_a?(Array)
    abort "Expected the JSON root to be an array of rooms"
  end

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

  if problems.any?
    abort "Refusing to import -- problems found:\n" + problems.map { |p| "  - #{p}" }.join("\n")
  end

  exit_count = 0
  npc_count = 0
  behavior_count = 0
  combat_behavior_count = 0

  ActiveRecord::Base.transaction do
    BehaviorAction.delete_all
    CombatBehavior.delete_all
    Behavior.delete_all
    Exit.delete_all
    Npc.delete_all
    Room.delete_all

    data.each do |r|
      Room.create!(id: r["id"], name: r["name"], description: r["description"])
    end

    data.each do |r|
      room = Room.find(r["id"])

      (r["exits"] || []).each do |e|
        room.exits.create!(linked_room_id: e["room_id"], key: e["key"], description: e["description"])
        exit_count += 1
      end

      (r["npcs"] || []).each do |n|
        char = n["character"] || {}
        npc = room.npcs.create!(
          id: n["id"],
          name: char["name"],
          description: n["description"],
          class_name: n["class"],
          level: char["level"],
          exp: char["exp_given"]
        )
        npc_count += 1

        (n["behavior"] || []).each do |b|
          behavior = npc.behaviors.create!(trigger: b["trigger"], chance: b["chance"])
          (b["actions"] || []).each do |action|
            behavior.actions.create!(action: action[0], payload: action[1])
          end
          behavior_count += 1
        end

        (n["combat_behavior"] || []).each do |cb|
          npc.combat_behaviors.create!(skill_name: cb["skill"], chance: cb["chance"])
          combat_behavior_count += 1
        end
      end
    end
  end

  puts "imported #{data.size} rooms, #{npc_count} npcs, #{exit_count} exits, " \
       "#{behavior_count} behaviors, #{combat_behavior_count} combat_behaviors from #{path}"
end
