module RoomsHelper
  # id => name for every room, built once per request from the @rooms
  # RoomsController#set_rooms already loads -- avoids a Room.find_by per
  # exit row just to resolve its target room's display name.
  def room_name_by_id
    @room_name_by_id ||= @rooms.index_by(&:id).transform_values(&:name)
  end
end
