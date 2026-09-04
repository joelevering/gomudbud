require "test_helper"

class RoomExportTest < ActiveSupport::TestCase
  test "round-trips SampleRoomData losslessly through import and back out" do
    original = SampleRoomData.rooms
    RoomImport.call(original)

    assert_equal original, RoomExport.call
  end

  test "omits npcs key entirely when a room has none" do
    RoomImport.call(SampleRoomData.rooms)

    room2 = RoomExport.call.find { |r| r["id"] == 2 }
    assert_not room2.key?("npcs")
  end

  test "omits behavior and combat_behavior keys when an npc has none" do
    RoomImport.call(SampleRoomData.rooms)

    room1 = RoomExport.call.find { |r| r["id"] == 1 }
    cat = room1["npcs"].find { |n| n["id"] == 2 }

    assert_not cat.key?("behavior")
    assert_not cat.key?("combat_behavior")
  end

  test "includes behavior and combat_behavior keys when an npc has them" do
    RoomImport.call(SampleRoomData.rooms)

    room1 = RoomExport.call.find { |r| r["id"] == 1 }
    guard = room1["npcs"].find { |n| n["id"] == 1 }

    assert_equal [ { "trigger" => "pc-enters", "actions" => [ [ "say", "Halt!" ] ], "chance" => 1.0 } ], guard["behavior"]
    assert_equal [ { "skill" => "slash", "chance" => 0.5 } ], guard["combat_behavior"]
  end
end
