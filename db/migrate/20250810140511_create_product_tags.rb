class CreateProductTags < ActiveRecord::Migration[8.0]
  def change
    create_table :product_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
