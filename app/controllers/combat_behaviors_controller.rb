class CombatBehaviorsController < ApplicationController
  before_action :set_combat_behavior, only: %i[ show edit update destroy ]

  # GET /combat_behaviors or /combat_behaviors.json
  def index
    @combat_behaviors = CombatBehavior.all
  end

  # GET /combat_behaviors/1 or /combat_behaviors/1.json
  def show
  end

  # GET /combat_behaviors/new
  def new
    @combat_behavior = CombatBehavior.new
  end

  # GET /combat_behaviors/1/edit
  def edit
  end

  # POST /combat_behaviors or /combat_behaviors.json
  def create
    @combat_behavior = CombatBehavior.new(combat_behavior_params)

    respond_to do |format|
      if @combat_behavior.save
        format.html { redirect_to @combat_behavior, notice: "Combat behavior was successfully created." }
        format.json { render :show, status: :created, location: @combat_behavior }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @combat_behavior.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /combat_behaviors/1 or /combat_behaviors/1.json
  def update
    respond_to do |format|
      if @combat_behavior.update(combat_behavior_params)
        format.html { redirect_to @combat_behavior, notice: "Combat behavior was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @combat_behavior }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @combat_behavior.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /combat_behaviors/1 or /combat_behaviors/1.json
  def destroy
    @combat_behavior.destroy!

    respond_to do |format|
      format.html { redirect_to combat_behaviors_path, notice: "Combat behavior was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_combat_behavior
      @combat_behavior = CombatBehavior.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def combat_behavior_params
      params.expect(combat_behavior: [ :npc_id, :skill_name, :chance ])
    end
end
