# app/models/user.rb
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one_attached :avatar
  validates :username, presence: true, uniqueness: true
  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy
  has_many :comment_likes, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy

  # Followed users (the ones this user is following)
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  # Followers (the ones following this user)
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
  
  has_many :mentions, dependent: :destroy
  has_many :mentioned_in, through: :mentions, source: :mentionable, source_type: 'Post'
  has_many :mentioned_comments, through: :mentions, source: :mentionable, source_type: 'Comment'

  validates :bio, length: { maximum: 500 }

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_representation_url(avatar.variant(resize_to_fill: [32, 32]), only_path: true) : nil
  end

end
