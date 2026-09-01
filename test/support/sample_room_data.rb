# A small hand-written GoMud rooms.json-shaped fixture shared by
# RoomImportTest and RoomExportTest, deliberately covering the shapes
# RoomExport must omit vs. include:
#   - room 2 has no npcs at all (the "npcs" key must be omitted on export)
#   - npc 2 has no behavior/combat_behavior (both keys must be omitted)
#   - npc 1 has both, including a multi-field behavior action
module SampleRoomData
  def self.rooms
    ROOMS.deep_dup
  end

  ROOMS = [
    {
      "id" => 1,
      "name" => "Test Area - Entry",
      "description" => "The entrance.",
      "exits" => [
        { "room_id" => 2, "key" => "n", "description" => "(N)orth into the hall" }
      ],
      "npcs" => [
        {
          "id" => 1,
          "description" => "A watchful guard",
          "class" => "Guard",
          "character" => { "name" => "Gareth", "level" => 3, "exp_given" => 30 },
          "behavior" => [
            { "trigger" => "pc-enters", "actions" => [ [ "say", "Halt!" ] ], "chance" => 1.0 }
          ],
          "combat_behavior" => [
            { "skill" => "slash", "chance" => 0.5 }
          ]
        },
        {
          "id" => 2,
          "description" => "A sleepy cat",
          "class" => "Cat",
          "character" => { "name" => "Mittens", "level" => 1, "exp_given" => 5 }
        }
      ]
    },
    {
      "id" => 2,
      "name" => "Test Area - Hall",
      "description" => "A long hall.",
      "exits" => [
        { "room_id" => 1, "key" => "s", "description" => "(S)outh back to the entrance" }
      ]
    }
  ].freeze
end
