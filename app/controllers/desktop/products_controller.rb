module Desktop
  class ProductsController < DesktopController
    def index
      @products = current_organisation.products
    end

    def new; end
    
    def create
      product = current_organisation.products.new

      product.assign_attributes(product_params)
      product.features = product_params[:features].split("\r\n")

      if product.save
        product.images.create!(name: "test_image", image: params[:product][:image]) if params[:product][:image]
        redirect_to desktop_product_path(product), notice: 'Product successfully created'
      else
        redirect_back fallback_location: desktop_products_new_path, alert: 'Invalid product information'
      end
    end

    def show
      @product = current_organisation.products.find(params[:id])
    end

    private

    def product_params
      params
        .require(:product)
        .permit(
          :name,
          :brand,
          :description,
          :price,
          :stock,
          :features,
          :item_number,
          :dimensions,
          :weight,
          :life_stage,
          :breed_size,
          :material
        )
    end
  end
end