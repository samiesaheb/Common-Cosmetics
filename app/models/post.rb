class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # 🌟 Validations
  validates :user, presence: true
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true

  # ✍️ Require caption if not a quote repost
  validates :caption, presence: true, unless: :repost?

  # ❤️ Likes
  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user

  # 💬 Comments
  has_many :comments, dependent: :destroy

  # 🔔 Mentions (polymorphic)
  has_many :mentions, as: :mentionable, dependent: :destroy

  # 📌 Bookmarks
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by, through: :bookmarks, source: :user

  # 🔁 Reposts + Quote Reposts
  belongs_to :original_post, class_name: "Post", optional: true
  has_many :reposts, class_name: "Post", foreign_key: :original_post_id, dependent: :nullify
  has_many :quote_reposts, class_name: "Post", foreign_key: "original_post_id", dependent: :nullify

  # 🏷️ Product Tagging
  has_many :post_product_tags, dependent: :destroy
  has_many :product_tags, through: :post_product_tags

  # ✨ Virtual attribute for form input
  attr_accessor :product_tag_names
  after_save :assign_product_tags

  # 🧠 Methods
  def repost?
    original_post_id.present?
  end

  def quote_repost?
    repost? && caption.present?
  end

  private

  def assign_product_tags
    return if product_tag_names.nil?

    tag_names = product_tag_names.split(",").map(&:strip).reject(&:blank?)
    normalized = tag_names.map { |n| n.titleize }

    self.product_tags = normalized.map do |tag_name|
      ProductTag.find_or_create_by(name: tag_name)
    end
  end
end
