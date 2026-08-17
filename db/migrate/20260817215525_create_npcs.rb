class CreateNpcs < ActiveRecord::Migration[8.1]
  def change
    create_table :npcs do |t|
      t.references :room, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :class_name
      t.integer :level
      t.integer :exp

      t.timestamps
    end
  end
end
