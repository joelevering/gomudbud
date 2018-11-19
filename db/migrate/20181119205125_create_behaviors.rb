class CreateBehaviors < ActiveRecord::Migration[5.2]
  def change
    create_table :behaviors do |t|
      t.string :trigger
      t.string :actions
      t.float :chance
      t.integer :npc_id
    end
  end
end
