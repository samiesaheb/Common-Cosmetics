class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true
  validates :rating, numericality: { in: 1..5 }, allow_nil: true
  
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
end
