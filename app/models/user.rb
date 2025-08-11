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
  
  has_many :comments, dependent: :destroy

  has_many :notifications,
           foreign_key: :recipient_id,
           dependent: :destroy,
           inverse_of: :recipient

  # (Optional) Notifications the user triggers as the actor
  has_many :activity_notifications,
           class_name: "Notification",
           foreign_key: :actor_id,
           dependent: :nullify,
           inverse_of: :actor

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
