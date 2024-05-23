class ShopController < ApplicationController
  def shop; end

  def show
    @product = Product.find(params[:id])
  end

  def review
    @product = Product.find(params[:id])
    @review = Review.new
  end

  def create_review
    @product = Product.find(params[:id])
    @product.reviews.create!(review_params)

    redirect_to product_path(@product)
  end

  def category
    @category = Category.find(params[:id])
    @products = @category.products
  end

  private

  def review_params
    review_params = params.require(:review).permit(:user_id, :rating, :comment)
    review_params[:user_id] = current_user.id
    review_params
  end
end