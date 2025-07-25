class AddLastTypingUserToConversations < ActiveRecord::Migration[8.0]
  def change
    add_reference :conversations, :last_typing_user, foreign_key: { to_table: :users }, null: true
  end
end
