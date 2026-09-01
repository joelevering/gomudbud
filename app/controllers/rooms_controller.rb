class RoomsController < ApplicationController
  NEW_ROOM_DEFAULTS = { name: "New Area - Untitled Room", description: "" }.freeze

  before_action :set_room, only: %i[ show edit update destroy ]
  before_action :set_rooms, only: %i[ index edit new create update map ]

  # GET /rooms
  def index
  end

  # GET /rooms/1
  def show
    redirect_to edit_room_path(@room)
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit -- rendered inside the "editor-panel" turbo frame
  def edit
  end

  # POST /rooms -- the header's "+ Add room" button posts with no room
  # params at all, so falls back to NEW_ROOM_DEFAULTS to create something
  # immediately editable; the /rooms/new form posts real params as usual.
  def create
    @room = Room.new(room_params.presence || NEW_ROOM_DEFAULTS)

    if @room.save
      redirect_to edit_room_path(@room), notice: "Room created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      redirect_to edit_room_path(@room), notice: "Room saved."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy!
    redirect_to rooms_path, notice: "Room deleted.", status: :see_other
  end

  # GET /rooms/map -- a minimal projection (not the full RoomExport shape) with
  # "area" precomputed server-side so the Map tab's JS never has to re-derive
  # it from the room name itself.
  def map
    @rooms_json = @rooms.map { |r|
      { id: r.id, name: r.name, area: r.area, exits: r.exits.pluck(:linked_room_id).map { |id| { room_id: id } } }
    }.to_json
  end

  # GET /rooms/export
  def export
    data = RoomExport.call
    send_data JSON.pretty_generate(data),
              filename: "rooms.export.json",
              type: "application/json",
              disposition: "attachment"
  end

  private
    def set_room
      @room = Room.find(params.expect(:id))
    end

    def set_rooms
      @rooms = Room.all.order(:id)
    end

    def room_params
      return {} unless params[:room]

      params.require(:room).permit(
        :name, :description,
        exits_attributes: [ :id, :key, :description, :linked_room_id, :_destroy ],
        npcs_attributes: [
          :id, :name, :description, :class_name, :level, :exp, :_destroy,
          behaviors_attributes: [
            :id, :trigger, :chance, :_destroy,
            actions_attributes: [ :id, :action, :payload, :_destroy ]
          ],
          combat_behaviors_attributes: [ :id, :skill_name, :chance, :_destroy ]
        ]
      )
    end
end
