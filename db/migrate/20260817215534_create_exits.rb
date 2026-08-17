class CreateExits < ActiveRecord::Migration[8.1]
  def change
    create_table :exits do |t|
      t.references :room, null: false, foreign_key: true
      t.integer :linked_room_id
      t.string :key
      t.string :description

      t.timestamps
    end
  end
end
