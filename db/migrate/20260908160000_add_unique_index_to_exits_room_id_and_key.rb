class AddUniqueIndexToExitsRoomIdAndKey < ActiveRecord::Migration[8.1]
  def change
    add_index :exits, [ :room_id, :key ], unique: true
  end
end
