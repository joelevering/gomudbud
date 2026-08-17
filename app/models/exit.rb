class Exit < ApplicationRecord
  belongs_to :room
  belongs_to :linked_room, class_name: "Room"
end
