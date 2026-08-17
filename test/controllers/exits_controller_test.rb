require "test_helper"

class ExitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exit = exits(:one)
  end

  test "should get index" do
    get exits_url
    assert_response :success
  end

  test "should get new" do
    get new_exit_url
    assert_response :success
  end

  test "should create exit" do
    assert_difference("Exit.count") do
      post exits_url, params: { exit: { description: @exit.description, key: @exit.key, linked_room_id: @exit.linked_room_id, room_id: @exit.room_id } }
    end

    assert_redirected_to exit_url(Exit.last)
  end

  test "should show exit" do
    get exit_url(@exit)
    assert_response :success
  end

  test "should get edit" do
    get edit_exit_url(@exit)
    assert_response :success
  end

  test "should update exit" do
    patch exit_url(@exit), params: { exit: { description: @exit.description, key: @exit.key, linked_room_id: @exit.linked_room_id, room_id: @exit.room_id } }
    assert_redirected_to exit_url(@exit)
  end

  test "should destroy exit" do
    assert_difference("Exit.count", -1) do
      delete exit_url(@exit)
    end

    assert_redirected_to exits_url
  end
end
