class BehaviorsController < ApplicationController

  def index
    @behaviors = Behavior.all
  end

  def new
    @behavior = Behavior.new
  end

  def create
    @behavior = Behavior.new(behavior_params)
    if @behavior.save
      redirect_to @behavior, alert: "Behavior created successfully."
    else
      redirect_to new_behavior_path, alert: "Error creating behavior."
    end
  end

  def show
    @behavior = Behavior.find(params[:id])
  end

  def edit
    @behavior = Behavior.find(params[:id])
  end

  def update
    @behavior = Behavior.find(params[:id])

    if @behavior.update!(behavior_params)
      redirect_to @behavior, alert: "Behavior created successfully."
    else
      redirect_to edit_behavior_path(@behavior), alert: "Error creating behavior."
    end
  end

  def destroy
    @behavior = Behavior.find(params[:id])

    if @behavior.destroy!
      redirect_to behaviors_path
    else
      redirect_to behavior_path(@behavior)
    end
  end

  private

  def behavior_params
    params.require(:behavior).permit(:trigger, :actions, :chance, :npc_id)
  end
end
