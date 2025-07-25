class ProductTag < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :post_product_tags, dependent: :destroy
  has_many :posts, through: :post_product_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_validation :normalize_name_and_slug

  private

  def normalize_name_and_slug
    self.name = name.strip.titleize if name.present?
    self.slug = name.parameterize if name.present?
  end
end
