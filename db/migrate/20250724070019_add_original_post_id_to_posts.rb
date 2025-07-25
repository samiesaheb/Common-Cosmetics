class AddOriginalPostIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :original_post, foreign_key: { to_table: :posts }
  end
end
