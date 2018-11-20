class CreateBehaviorActions < ActiveRecord::Migration[5.2]
  def change
    create_table :behavior_actions do |t|
      t.string :action
      t.string :payload
      t.integer :behavior_id
    end
  end
end
