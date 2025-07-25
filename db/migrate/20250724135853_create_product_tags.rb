class CreateProductTags < ActiveRecord::Migration[7.1]
  def change
    create_table :product_tags do |t|
      t.string :name
      t.string :slug, null: false

      t.timestamps
    end

    add_index :product_tags, :slug, unique: true
  end
end
