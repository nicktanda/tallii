module Desktop
  class ProductsController < DesktopController
    def index
      @products = current_organisation.products
    end

    def new
      @categories = current_organisation.categories
    end
    
    def create
      product = current_organisation.products.new

      product.assign_attributes(product_params)
      product.features = product_params[:features].split("\r\n")

      if product.save
        product.images.create!(name: "test_image", image: params[:product][:image]) if params[:product][:image]

        params[:product][:category_ids].each do |category_id|
          product.product_category_joins.create!(category_id: category_id)
        end

        redirect_to desktop_product_path(product), notice: 'Product successfully created'
      else
        redirect_back fallback_location: desktop_products_new_path, alert: 'Invalid product information'
      end
    end

    def update
      product = current_organisation.products.find(params[:id])

      product.assign_attributes(product_params)
      product.features = product_params[:features].split("\r\n")

      product.product_category_joins.destroy_all
      params[:product][:category_ids].each do |category_id|
        product.product_category_joins.create!(category_id: category_id)
      end

      if product.save
        product.images.create!(name: "test_image", image: params[:product][:image]) if params[:product][:image]
        redirect_to desktop_product_path(product), notice: 'Product successfully updated'
      else
        redirect_back fallback_location: desktop_products_new_path, alert: 'Invalid product information'
      end
    end

    def show
      @product = current_organisation.products.find(params[:id])
    end

    def edit
      @product = current_organisation.products.find(params[:id])
      @categories = current_organisation.categories
    end

    def delete
      product = current_organisation.products.find(params[:id])
      product.destroy

      redirect_to desktop_products_path
    end

    def pictures
      @product = current_organisation.products.find(params[:id])
    end

    def upload_new_image
      product = current_organisation.products.find(params[:id])
      product.images.create!(name: "test_image", image: params[:image])
      redirect_to desktop_product_pictures_path(product), notice: 'Image uploaded'
    end

    def delete_product_picture
      product = current_organisation.products.find(params[:id])

      image = product.images.find(params[:image_id])
      if product.images.count > 1
        image.destroy
        redirect_to desktop_product_pictures_path(product), notice: 'Image deleted'
      else
        redirect_to desktop_product_pictures_path(product), notice: 'Product needs to always have at least 1 photo'
      end
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