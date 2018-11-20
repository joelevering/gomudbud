class RoomsController < ApplicationController

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to @room, alert: "Room created successfully."
    else
      redirect_to new_room_path, alert: "Error creating room."
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])

    if @room.update!(room_params)
      redirect_to @room, alert: "Room created successfully."
    else
      redirect_to edit_room_path(@room), alert: "Error creating room."
    end
  end

  def destroy
    @room = Room.find(params[:id])

    if @room.destroy!
      redirect_to rooms_path
    else
      redirect_to room_path(@room)
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :description)
  end
end
