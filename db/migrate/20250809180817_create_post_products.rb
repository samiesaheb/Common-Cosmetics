class CreatePostProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :post_products do |t|
      t.references :post,    null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end
    add_index :post_products, [:post_id, :product_id], unique: true
  end
end
