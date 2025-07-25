class CreatePostProductTags < ActiveRecord::Migration[8.0]
  def change
    create_table :post_product_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :product_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
