desc "Export Rooms to JSON"
task export_rooms: :environment do
  path = ENV["OUTPUT"] || Rails.root.join("tmp", "rooms.export.json").to_s
  data = RoomExport.call

  File.write(path, JSON.pretty_generate(data))

  npc_count = data.sum { |r| (r["npcs"] || []).size }
  puts "exported #{data.size} rooms, #{npc_count} npcs to #{path}"
end
