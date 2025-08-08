class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  validates :username, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy

  # Users this user is following
  has_many :followed_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy

  has_many :following, through: :followed_relationships, source: :followed

  # Users that follow this user
  has_many :follower_relationships, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy

  has_many :followers, through: :follower_relationships, source: :follower

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
