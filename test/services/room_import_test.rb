require "test_helper"

class RoomImportTest < ActiveSupport::TestCase
  test "imports rooms, exits, npcs, behaviors, and combat_behaviors" do
    result = RoomImport.call(SampleRoomData.rooms)

    assert_equal 2, result.rooms
    assert_equal 2, result.npcs
    assert_equal 2, result.exits
    assert_equal 1, result.behaviors
    assert_equal 1, result.combat_behaviors

    room1 = Room.find(1)
    assert_equal "Test Area - Entry", room1.name
    assert_equal [ 2 ], room1.exits.pluck(:linked_room_id)

    guard = Npc.find(1)
    assert_equal "Gareth", guard.name
    assert_equal "Guard", guard.class_name
    assert_equal 1, guard.behaviors.count
    assert_equal [ [ "say", "Halt!" ] ], guard.behaviors.first.actions.map { |a| [ a.action, a.payload ] }
    assert_equal "slash", guard.combat_behaviors.first.skill_name
  end

  test "is a full replace -- prior data is gone after a second import" do
    RoomImport.call(SampleRoomData.rooms)
    assert_equal 2, Room.count

    smaller = [ SampleRoomData.rooms.first.merge("exits" => [], "npcs" => []) ]
    RoomImport.call(smaller)

    assert_equal 1, Room.count
    assert_equal 0, Npc.count
  end

  test "raises on duplicate room ids and does not touch the database" do
    data = SampleRoomData.rooms
    data << data.first.merge("name" => "Duplicate")

    assert_no_difference "Room.count" do
      error = assert_raises(RoomImport::ValidationError) { RoomImport.call(data) }
      assert_match(/duplicate room ids: \[1\]/, error.message)
    end
  end

  test "raises on an exit pointing at a room id that doesn't exist" do
    data = SampleRoomData.rooms
    data.first["exits"] << { "room_id" => 999, "key" => "x", "description" => "nowhere" }

    error = assert_raises(RoomImport::ValidationError) { RoomImport.call(data) }
    assert_match(/dangling exit targets/, error.message)
    assert_match(/999/, error.message)
  end

  test "raises on duplicate npc ids" do
    data = SampleRoomData.rooms
    data.first["npcs"] << data.first["npcs"].first.merge("description" => "another guard")

    error = assert_raises(RoomImport::ValidationError) { RoomImport.call(data) }
    assert_match(/duplicate npc ids: \[1\]/, error.message)
  end
end
