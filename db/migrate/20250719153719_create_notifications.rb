class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.string :action
      t.datetime :read_at

      t.timestamps
    end
  end
end
