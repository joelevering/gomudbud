require "test_helper"

class NpcsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @npc = npcs(:one)
  end

  test "should get index" do
    get npcs_url
    assert_response :success
  end

  test "should get new" do
    get new_npc_url
    assert_response :success
  end

  test "should create npc" do
    assert_difference("Npc.count") do
      post npcs_url, params: { npc: { class_name: @npc.class_name, description: @npc.description, exp: @npc.exp, level: @npc.level, name: @npc.name, room_id: @npc.room_id } }
    end

    assert_redirected_to npc_url(Npc.last)
  end

  test "should show npc" do
    get npc_url(@npc)
    assert_response :success
  end

  test "should get edit" do
    get edit_npc_url(@npc)
    assert_response :success
  end

  test "should update npc" do
    patch npc_url(@npc), params: { npc: { class_name: @npc.class_name, description: @npc.description, exp: @npc.exp, level: @npc.level, name: @npc.name, room_id: @npc.room_id } }
    assert_redirected_to npc_url(@npc)
  end

  test "should destroy npc" do
    assert_difference("Npc.count", -1) do
      delete npc_url(@npc)
    end

    assert_redirected_to npcs_url
  end
end
