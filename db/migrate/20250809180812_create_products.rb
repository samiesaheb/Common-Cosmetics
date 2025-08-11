class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name,  null: false
      t.string :brand
      t.string :slug,  null: false
      t.timestamps
    end
    add_index :products, :name
    add_index :products, :slug, unique: true
  end
end
