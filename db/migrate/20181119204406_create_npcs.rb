class CreateNpcs < ActiveRecord::Migration[5.2]
  def change
    create_table :npcs do |t|
      t.string :name
      t.string :description
      t.string :class_name
      t.integer :level
      t.integer :exp
      t.integer :room_id
    end
  end
end
