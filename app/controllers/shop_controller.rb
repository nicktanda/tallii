class ShopController < ApplicationController
  def shop; end

  def show
    @product = Product.find(params[:id])
  end
end