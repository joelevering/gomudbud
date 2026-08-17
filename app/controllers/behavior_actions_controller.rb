class BehaviorActionsController < ApplicationController
  before_action :set_behavior
  before_action :set_behavior_action, only: %i[ show edit update destroy ]

  # GET /behaviors/1/actions or /behaviors/1/actions.json
  def index
    @behavior_actions = @behavior.actions
  end

  # GET /behaviors/1/actions/1 or /behaviors/1/actions/1.json
  def show
  end

  # GET /behaviors/1/actions/new
  def new
    @behavior_action = @behavior.actions.build
  end

  # GET /behaviors/1/actions/1/edit
  def edit
  end

  # POST /behaviors/1/actions or /behaviors/1/actions.json
  def create
    @behavior_action = @behavior.actions.build(behavior_action_params)

    respond_to do |format|
      if @behavior_action.save
        format.html { redirect_to behavior_action_path(@behavior, @behavior_action), notice: "Behavior action was successfully created." }
        format.json { render :show, status: :created, location: behavior_action_path(@behavior, @behavior_action) }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @behavior_action.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /behaviors/1/actions/1 or /behaviors/1/actions/1.json
  def update
    respond_to do |format|
      if @behavior_action.update(behavior_action_params)
        format.html { redirect_to behavior_action_path(@behavior, @behavior_action), notice: "Behavior action was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: behavior_action_path(@behavior, @behavior_action) }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @behavior_action.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /behaviors/1/actions/1 or /behaviors/1/actions/1.json
  def destroy
    @behavior_action.destroy!

    respond_to do |format|
      format.html { redirect_to behavior_actions_path(@behavior), notice: "Behavior action was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_behavior
      @behavior = Behavior.find(params[:behavior_id])
    end

    def set_behavior_action
      @behavior_action = @behavior.actions.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def behavior_action_params
      params.expect(behavior_action: [ :action, :payload ])
    end
end
