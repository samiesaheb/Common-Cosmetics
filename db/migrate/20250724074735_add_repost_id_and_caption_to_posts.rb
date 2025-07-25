class AddRepostIdAndCaptionToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :repost_id, :integer
  end
end
