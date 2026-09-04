desc "Import a GoMud rooms.json file into the database (full replace)"
task :import_rooms, [ :path ] => :environment do |_t, args|
  path = args[:path] || File.expand_path("../gomud/data/rooms.json", Rails.root)

  unless File.exist?(path)
    abort "No file at #{path}"
  end

  data = JSON.parse(File.read(path))

  begin
    result = RoomImport.call(data)
  rescue RoomImport::ValidationError => e
    abort "Refusing to import -- problems found: #{e.message}"
  end

  puts "imported #{result.rooms} rooms, #{result.npcs} npcs, #{result.exits} exits, " \
       "#{result.behaviors} behaviors, #{result.combat_behaviors} combat_behaviors from #{path}"
end
