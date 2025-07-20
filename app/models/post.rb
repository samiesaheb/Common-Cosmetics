class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :caption, presence: true
  validates :rating, inclusion: { in: 1..5 }
  validates :user, presence: true

  has_many :likes, dependent: :destroy
  has_many :liked_by, through: :likes, source: :user

  has_many :comments, dependent: :destroy

  has_many :mentions, as: :mentionable, dependent: :destroy

end
