class PostProductTag < ApplicationRecord
  belongs_to :post
  belongs_to :product_tag

  validates :post_id, uniqueness: { scope: :product_tag_id }
end
