class AddTypingToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :typing, :boolean
  end
end
