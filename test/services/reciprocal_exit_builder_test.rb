require "test_helper"

class ReciprocalExitBuilderTest < ActiveSupport::TestCase
  setup do
    RoomImport.call(SampleRoomData.rooms)
    @room1 = Room.find(1)
    # SampleRoomData's room 2 already exits back to room 1 -- use a fresh,
    # unconnected room so "creates a new reciprocal" isn't muddied by that.
    @room3 = Room.create!(name: "Test Area - Vault", description: "A locked vault.")
  end

  # ReciprocalExitBuilder reads the *in-memory* create_reciprocal/reciprocal_*
  # values off room.exits, mirroring how RoomsController calls it right after
  # @room.update(room_params) -- these virtual attributes are never persisted,
  # so none of these tests reload @room1 in between building the exit and
  # calling the builder.

  test "creates a return exit on the target room" do
    @room1.exits.create!(
      key: "e", description: "east to the vault", linked_room_id: @room3.id,
      create_reciprocal: "1", reciprocal_key: "w", reciprocal_description: "west back"
    )

    assert_difference "@room3.exits.count", 1 do
      ReciprocalExitBuilder.call(@room1)
    end

    reciprocal = @room3.exits.find_by(linked_room_id: @room1.id, key: "w")
    assert reciprocal
    assert_equal "west back", reciprocal.description
  end

  test "updates an already-existing reciprocal instead of duplicating it" do
    exit = @room1.exits.create!(
      key: "e", description: "east to the vault", linked_room_id: @room3.id,
      create_reciprocal: "1", reciprocal_key: "w", reciprocal_description: "west back"
    )
    ReciprocalExitBuilder.call(@room1)
    assert_equal 1, @room3.exits.where(linked_room_id: @room1.id).count

    exit.reciprocal_description = "west, changed"
    ReciprocalExitBuilder.call(@room1)

    assert_equal 1, @room3.exits.where(linked_room_id: @room1.id).count
    assert_equal "west, changed", @room3.exits.find_by(linked_room_id: @room1.id).description
  end

  test "no-ops when the exit's target room doesn't exist" do
    exit = @room1.exits.build(key: "z", description: "into the void", linked_room_id: 999, create_reciprocal: "1")
    exit.save(validate: false)

    assert_nothing_raised { ReciprocalExitBuilder.call(@room1) }
  end

  test "does nothing for exits that didn't request a reciprocal" do
    @room1.exits.create!(key: "e", description: "east to the vault", linked_room_id: @room3.id)

    assert_no_difference "@room3.exits.count" do
      ReciprocalExitBuilder.call(@room1)
    end
  end
end
