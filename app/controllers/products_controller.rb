# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:autocomplete]  # optional

  def index
    @q = params[:q].to_s.strip
    @products = Product.search(@q).order(:name).limit(50)
  end

  def show
    @product = Product.find_by!(slug: params[:id])
    @posts = @product.posts.order(created_at: :desc).includes(:user)
  end

  def autocomplete
    q = params[:q].to_s.strip
    @products = Product.search(q).order(:name).limit(8)
    render json: @products.map { |p| { id: p.id, label: [p.brand, p.name].compact.join(": "), name: p.name, brand: p.brand } }
  end
end
