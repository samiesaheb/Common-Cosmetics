class ProductTag < ApplicationRecord
  belongs_to :post
  belongs_to :product

  # Notify all followers of this product when it's tagged in a post
  after_create :notify_product_followers

  private
  def notify_product_followers
    actor = post.user
    product.followers.find_each do |follower|
      next if follower.id == actor.id
      Notification.create!(
        recipient: follower,
        actor: actor,
        action: "tagged_followed_product",
        notifiable: self,
        metadata: {
          product_id: product.id,
          product_name: product.name,
          post_id: post.id
        }
      )
    end
  end
end
