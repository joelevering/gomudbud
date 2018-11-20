class RemoveActionsFromBehaviors < ActiveRecord::Migration[5.2]
  def change
    remove_column :behaviors, :actions
  end
end
