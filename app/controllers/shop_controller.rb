class ShopController < ApplicationController
  def shop; end

  def product
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

  def add_to_cart
    return unless session["user"]["id"] == current_user.id

    session["user"]["cart"] ||= []
    session["user"]["cart"] << params[:id]

    redirect_to cart_path
  end

  def cart
    cart = session["user"]["cart"]
    @cart_products = cart.group_by(&:itself).transform_values(&:count).map do |product_id, quantity|
      product = Product.find(product_id)
      
      { product: product, quantity: quantity }
    end
  end

  private

  def review_params
    review_params = params.require(:review).permit(:user_id, :rating, :comment)
    review_params[:user_id] = current_user.id
    review_params
  end
end