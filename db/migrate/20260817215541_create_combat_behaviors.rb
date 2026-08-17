class CreateCombatBehaviors < ActiveRecord::Migration[8.1]
  def change
    create_table :combat_behaviors do |t|
      t.references :npc, null: false, foreign_key: true
      t.string :skill_name
      t.float :chance

      t.timestamps
    end
  end
end
