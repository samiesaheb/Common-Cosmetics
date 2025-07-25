# app/controllers/product_tags_controller.rb
class ProductTagsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: ProductTag.select(:id, :name).order(:name) }
    end
  end

  def show
    @product_tag = ProductTag.friendly.find(params[:id])
    @posts = @product_tag.posts.includes(:user).order(created_at: :desc)
  end
end
