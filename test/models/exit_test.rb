require "test_helper"

class ExitTest < ActiveSupport::TestCase
  setup do
    RoomImport.call(SampleRoomData.rooms)
    @room1 = Room.find(1)
    @room2 = Room.find(2)
  end

  test "rejects a duplicate exit key within the same room, case-insensitively" do
    exit = @room1.exits.build(key: "N", description: "another way north", linked_room_id: @room2.id)
    assert_not exit.valid?
    assert_includes exit.errors[:key], "is already used by another exit from this room"
  end

  test "allows the same key on exits from different rooms" do
    exit = @room2.exits.build(key: "n", description: "north from the hall", linked_room_id: @room1.id)
    assert exit.valid?
  end

  test "requires linked_room_id to reference an existing room" do
    exit = @room1.exits.build(key: "x", description: "nowhere", linked_room_id: 999)
    assert_not exit.valid?
  end

  test "create_reciprocal? casts the checkbox string value" do
    exit = Exit.new
    assert_not exit.create_reciprocal?

    exit.create_reciprocal = "0"
    assert_not exit.create_reciprocal?

    exit.create_reciprocal = "1"
    assert exit.create_reciprocal?
  end
end
