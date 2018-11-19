class CreateExits < ActiveRecord::Migration[5.2]
  def change
    create_table :exits do |t|
      t.integer :room_id
      t.integer :linked_room_id
      t.string :key
      t.string :description
    end
  end
end
