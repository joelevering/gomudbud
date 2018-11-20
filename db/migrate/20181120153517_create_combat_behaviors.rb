class CreateCombatBehaviors < ActiveRecord::Migration[5.2]
  def change
    create_table :combat_behaviors do |t|
      t.string :skill_name
      t.float :chance
      t.integer :npc_id
    end
  end
end
