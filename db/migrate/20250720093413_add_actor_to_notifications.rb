class AddActorToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_reference :notifications, :actor, foreign_key: { to_table: :users }
  end
end
