require "test_helper"

class CombatBehaviorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @combat_behavior = combat_behaviors(:one)
  end

  test "should get index" do
    get combat_behaviors_url
    assert_response :success
  end

  test "should get new" do
    get new_combat_behavior_url
    assert_response :success
  end

  test "should create combat_behavior" do
    assert_difference("CombatBehavior.count") do
      post combat_behaviors_url, params: { combat_behavior: { chance: @combat_behavior.chance, npc_id: @combat_behavior.npc_id, skill_name: @combat_behavior.skill_name } }
    end

    assert_redirected_to combat_behavior_url(CombatBehavior.last)
  end

  test "should show combat_behavior" do
    get combat_behavior_url(@combat_behavior)
    assert_response :success
  end

  test "should get edit" do
    get edit_combat_behavior_url(@combat_behavior)
    assert_response :success
  end

  test "should update combat_behavior" do
    patch combat_behavior_url(@combat_behavior), params: { combat_behavior: { chance: @combat_behavior.chance, npc_id: @combat_behavior.npc_id, skill_name: @combat_behavior.skill_name } }
    assert_redirected_to combat_behavior_url(@combat_behavior)
  end

  test "should destroy combat_behavior" do
    assert_difference("CombatBehavior.count", -1) do
      delete combat_behavior_url(@combat_behavior)
    end

    assert_redirected_to combat_behaviors_url
  end
end
