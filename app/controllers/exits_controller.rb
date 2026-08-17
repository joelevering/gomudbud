class ExitsController < ApplicationController
  before_action :set_exit, only: %i[ show edit update destroy ]

  # GET /exits or /exits.json
  def index
    @exits = Exit.all
  end

  # GET /exits/1 or /exits/1.json
  def show
  end

  # GET /exits/new
  def new
    @exit = Exit.new
  end

  # GET /exits/1/edit
  def edit
  end

  # POST /exits or /exits.json
  def create
    @exit = Exit.new(exit_params)

    respond_to do |format|
      if @exit.save
        format.html { redirect_to @exit, notice: "Exit was successfully created." }
        format.json { render :show, status: :created, location: @exit }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @exit.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /exits/1 or /exits/1.json
  def update
    respond_to do |format|
      if @exit.update(exit_params)
        format.html { redirect_to @exit, notice: "Exit was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @exit }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @exit.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /exits/1 or /exits/1.json
  def destroy
    @exit.destroy!

    respond_to do |format|
      format.html { redirect_to exits_path, notice: "Exit was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exit
      @exit = Exit.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def exit_params
      params.expect(exit: [ :room_id, :linked_room_id, :key, :description ])
    end
end
