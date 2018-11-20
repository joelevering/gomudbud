class CombatBehaviorsController < ApplicationController

  def index
    @combat_behaviors = CombatBehavior.all
  end

  def new
    @combat_behavior = CombatBehavior.new
  end

  def create
    @combat_behavior = CombatBehavior.new(combat_behavior_params)
    if @combat_behavior.save
      redirect_to @combat_behavior, alert: "CombatBehavior created successfully."
    else
      redirect_to new_combat_behavior_path, alert: "Error creating combat behavior."
    end
  end

  def show
    @combat_behavior = CombatBehavior.find(params[:id])
  end

  def edit
    @combat_behavior = CombatBehavior.find(params[:id])
  end

  def update
    @combat_behavior = CombatBehavior.find(params[:id])

    if @combat_behavior.update!(combat_behavior_params)
      redirect_to @combat_behavior, alert: "CombatBehavior created successfully."
    else
      redirect_to edit_combat_behavior_path(@combat_behavior), alert: "Error creating combat behavior."
    end
  end

  def destroy
    @combat_behavior = CombatBehavior.find(params[:id])

    if @combat_behavior.destroy!
      redirect_to combat_behaviors_path
    else
      redirect_to combat_behavior_path(@combat_behavior)
    end
  end

  private

  def combat_behavior_params
    params.require(:combat_behavior).permit(:skill_name, :chance, :npc_id)
  end
end
