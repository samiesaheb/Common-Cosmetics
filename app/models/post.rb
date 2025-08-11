class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true
  validates :rating, numericality: { in: 1..5 }, allow_nil: true

  # ✅ Polymorphic likes
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :comments, dependent: :destroy

  # ✅ Product tagging association
  has_many :post_products, dependent: :destroy
  has_many :products, through: :post_products

  # Helpers for assigning product tags
  def product_names=(names)
    return if names.nil?
    list = names.split(",").map(&:strip).reject(&:blank?).uniq
    self.products = list.map do |n|
      if n.include?(":")
        brand, pname = n.split(":", 2).map(&:strip)
        Product.where("LOWER(name)=? AND LOWER(brand)=?", pname.downcase, brand.downcase)
               .first_or_create!(name: pname, brand: brand)
      else
        Product.where("LOWER(name)=?", n.downcase)
               .first_or_create!(name: n)
      end
    end
  end

  def product_names
    products.map { |p| [p.brand, p.name].compact.join(": ") }.join(", ")
  end
end
