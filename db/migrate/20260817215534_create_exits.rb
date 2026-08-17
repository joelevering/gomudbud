class CreateExits < ActiveRecord::Migration[8.1]
  def change
    create_table :exits do |t|
      t.references :room, foreign_key: false, index: false
      t.integer :linked_room_id
      t.string :key
      t.string :description

      t.timestamps
    end
  end
end
