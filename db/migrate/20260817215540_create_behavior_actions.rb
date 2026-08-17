class CreateBehaviorActions < ActiveRecord::Migration[8.1]
  def change
    create_table :behavior_actions do |t|
      t.references :behavior, foreign_key: false, index: false
      t.string :action
      t.string :payload

      t.timestamps
    end
  end
end
