class BehaviorActionsController < ApplicationController

  def index
    @behavior_actions = BehaviorAction.all
  end

  def new
    @behavior_action = BehaviorAction.new
  end

  def create
    @behavior_action = BehaviorAction.new(behavior_action_params)
    if @behavior_action.save
      redirect_to behavior_action_path(behavior_id: @behavior_action.behavior_id, id: @behavior_action.id), alert: "Behavior Action created successfully."
    else
      redirect_to new_behavior_action_path, alert: "Error creating behavior action."
    end
  end

  def show
    @behavior_action = BehaviorAction.find(params[:id])
  end

  def edit
    @behavior_action = BehaviorAction.find(params[:id])
  end

  def update
    @behavior_action = BehaviorAction.find(params[:id])

    if @behavior_action.update!(behavior_action_params)
      redirect_to @behavior_action, alert: "Behavior Action created successfully."
    else
      redirect_to edit_behavior_action_path(@behavior_action), alert: "Error creating behavior action."
    end
  end

  def destroy
    @behavior_action = BehaviorAction.find(params[:id])

    if @behavior_action.destroy!
      redirect_to behavior_actions_path
    else
      redirect_to behavior_action_path(@behavior_action)
    end
  end

  private

  def behavior_action_params
    params.require(:behavior_action).permit(:action, :payload, :behavior_id)
  end
end
