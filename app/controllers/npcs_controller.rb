class NpcsController < ApplicationController

  def index
    @npcs = Npc.all
  end

  def new
    @npc = Npc.new
  end

  def create
    @npc = Npc.new(npc_params)
    if @npc.save
      redirect_to @npc, alert: "Npc created successfully."
    else
      redirect_to new_npc_path, alert: "Error creating npc."
    end
  end

  def show
    @npc = Npc.find(params[:id])
  end

  def edit
    @npc = Npc.find(params[:id])
  end

  def update
    @npc = Npc.find(params[:id])

    if @npc.update!(npc_params)
      redirect_to @npc, alert: "Npc created successfully."
    else
      redirect_to edit_npc_path(@npc), alert: "Error creating npc."
    end
  end

  def destroy
    @npc = Npc.find(params[:id])

    if @npc.destroy!
      redirect_to npcs_path
    else
      redirect_to npc_path(@npc)
    end
  end

  private

  def npc_params
    params.require(:npc).permit(:name, :description, :class_name, :level, :exp, :room_id)
  end
end
