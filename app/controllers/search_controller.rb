class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    q = params[:q].to_s.strip

    if turbo_frame_request?
      users = q.present? ? User.where(
        "username ILIKE :q OR first_name ILIKE :q OR last_name ILIKE :q",
        q: "%#{q}%"
      ).limit(8) : User.none

      products = q.present? ? Product.search(q).order(:name).limit(8) : Product.none

      render partial: "search/suggestions", locals: { q: q, users: users, products: products }

    else
      # Full page results
      @users = q.present? ? User.where(
        "username ILIKE :q OR first_name ILIKE :q OR last_name ILIKE :q",
        q: "%#{q}%"
      ).limit(50) : User.none

      # ✅ Also match posts by associated products (name/brand)
      @posts = if q.present?
        Post
          .left_outer_joins(:products)
          .where(
            "posts.content ILIKE :q OR products.name ILIKE :q OR products.brand ILIKE :q",
            q: "%#{q}%"
          )
          .distinct
          .includes(:user, :products, image_attachment: :blob)
          .limit(50)
      else
        Post.none
      end

      render :index
    end
  end
end
