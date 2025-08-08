json.extract! post, :id, :user_id, :content, :image, :rating, :created_at, :updated_at
json.url post_url(post, format: :json)
json.image url_for(post.image)
