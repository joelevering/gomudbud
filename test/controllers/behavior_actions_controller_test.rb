require "test_helper"

class BehaviorActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @behavior_action = behavior_actions(:one)
    @behavior = @behavior_action.behavior
  end

  test "should get index" do
    get behavior_actions_url(@behavior)
    assert_response :success
  end

  test "should get new" do
    get new_behavior_action_url(@behavior)
    assert_response :success
  end

  test "should create behavior_action" do
    assert_difference("BehaviorAction.count") do
      post behavior_actions_url(@behavior), params: { behavior_action: { action: @behavior_action.action, payload: @behavior_action.payload } }
    end

    assert_redirected_to behavior_action_url(@behavior, BehaviorAction.last)
  end

  test "should show behavior_action" do
    get behavior_action_url(@behavior, @behavior_action)
    assert_response :success
  end

  test "should get edit" do
    get edit_behavior_action_url(@behavior, @behavior_action)
    assert_response :success
  end

  test "should update behavior_action" do
    patch behavior_action_url(@behavior, @behavior_action), params: { behavior_action: { action: @behavior_action.action, payload: @behavior_action.payload } }
    assert_redirected_to behavior_action_url(@behavior, @behavior_action)
  end

  test "should destroy behavior_action" do
    assert_difference("BehaviorAction.count", -1) do
      delete behavior_action_url(@behavior, @behavior_action)
    end

    assert_redirected_to behavior_actions_url(@behavior)
  end
end
