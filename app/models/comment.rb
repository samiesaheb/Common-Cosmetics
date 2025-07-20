class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  has_many :comment_likes, dependent: :destroy

  validates :body, presence: true

  has_many :mentions, as: :mentionable, dependent: :destroy

end
