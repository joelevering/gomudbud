class ExitsController < ApplicationController

  def index
    @exits = Exit.includes(:room).order("rooms.name")
  end

  def new
    @exit = Exit.new
  end

  def create
    @exit = Exit.new(exit_params)
    if @exit.save
      redirect_to @exit, alert: "Exit created successfully."
    else
      redirect_to new_exit_path, alert: "Error creating room."
    end
  end

  def show
    @exit = Exit.find(params[:id])
  end

  def edit
    @exit = Exit.find(params[:id])
  end

  def update
    @exit = Exit.find(params[:id])

    if @exit.update!(exit_params)
      redirect_to @exit, alert: "Exit created successfully."
    else
      redirect_to edit_exit_path(@exit), alert: "Error creating exit."
    end
  end

  def destroy
    @exit = Exit.find(params[:id])

    if @exit.destroy!
      redirect_to exits_path
    else
      redirect_to exit_path(@exit)
    end
  end

  private

  def exit_params
    params.require(:exit).permit(:key, :description, :room_id, :linked_room_id)
  end
end
