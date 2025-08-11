# app/models/product.rb
class Product < ApplicationRecord
  has_many :post_products, dependent: :destroy
  has_many :posts, through: :post_products

  before_validation :set_slug

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :name, uniqueness: { scope: :brand, case_sensitive: false } # <-- add scope

  has_many :product_tags, dependent: :destroy
  has_many :posts, through: :product_tags

  has_many :product_follows, dependent: :destroy
  has_many :followers, through: :product_follows, source: :user

  scope :search, ->(q) { q.present? ? where("name ILIKE :q OR brand ILIKE :q", q: "%#{q}%") : none }

  def to_param = slug

  private
  def set_slug
    base = [brand, name].compact.join(" ").strip
    self.slug = base.parameterize if slug.blank? && base.present?
  end
end
