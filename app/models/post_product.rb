# app/models/post_product.rb
class PostProduct < ApplicationRecord
  belongs_to :post
  belongs_to :product
end