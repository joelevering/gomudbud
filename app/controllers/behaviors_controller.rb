class BehaviorsController < ApplicationController
  before_action :set_behavior, only: %i[ show edit update destroy ]

  # GET /behaviors or /behaviors.json
  def index
    @behaviors = Behavior.all
  end

  # GET /behaviors/1 or /behaviors/1.json
  def show
  end

  # GET /behaviors/new
  def new
    @behavior = Behavior.new
  end

  # GET /behaviors/1/edit
  def edit
  end

  # POST /behaviors or /behaviors.json
  def create
    @behavior = Behavior.new(behavior_params)

    respond_to do |format|
      if @behavior.save
        format.html { redirect_to @behavior, notice: "Behavior was successfully created." }
        format.json { render :show, status: :created, location: @behavior }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @behavior.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /behaviors/1 or /behaviors/1.json
  def update
    respond_to do |format|
      if @behavior.update(behavior_params)
        format.html { redirect_to @behavior, notice: "Behavior was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @behavior }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @behavior.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /behaviors/1 or /behaviors/1.json
  def destroy
    @behavior.destroy!

    respond_to do |format|
      format.html { redirect_to behaviors_path, notice: "Behavior was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_behavior
      @behavior = Behavior.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def behavior_params
      params.expect(behavior: [ :npc_id, :trigger, :chance ])
    end
end
