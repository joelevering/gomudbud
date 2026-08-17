class CreateBehaviors < ActiveRecord::Migration[8.1]
  def change
    create_table :behaviors do |t|
      t.references :npc, foreign_key: false, index: false
      t.string :trigger
      t.float :chance

      t.timestamps
    end
  end
end
