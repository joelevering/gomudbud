class CreateBehaviorActions < ActiveRecord::Migration[8.1]
  def change
    create_table :behavior_actions do |t|
      t.references :behavior, null: false, foreign_key: true
      t.string :action
      t.string :payload

      t.timestamps
    end
  end
end
