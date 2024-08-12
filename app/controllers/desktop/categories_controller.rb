module Desktop
  class CategoriesController < DesktopController
    def index
      @categories = current_organisation.categories
    end

    def new; end
    
    def create
      category = current_organisation.categories.new

      category.assign_attributes(category_params)

      if category.save
        category.images.create!(name: "test_image", image: params[:category][:image]) if params[:category][:image]
        redirect_to desktop_category_path(category), notice: 'Category successfully created'
      else
        redirect_back fallback_location: desktop_categories_new_path, alert: 'Invalid category information'
      end
    end

    def update
      category = current_organisation.categories.find(params[:id])

      category.assign_attributes(category_params)

      if category.save
        category.images.create!(name: "test_image", image: params[:category][:image]) if params[:category][:image]
        redirect_to desktop_category_path(category), notice: 'Category successfully updated'
      else
        redirect_back fallback_location: desktop_categories_new_path, alert: 'Invalid category information'
      end
    end

    def show
      @category = current_organisation.categories.find(params[:id])
    end

    def edit
      @category = current_organisation.categories.find(params[:id])
    end

    def delete
      category = current_organisation.categories.find(params[:id])
      category.destroy

      redirect_to desktop_categories_path
    end

    def pictures
      @category = current_organisation.categories.find(params[:id])
    end

    def upload_new_image
      category = current_organisation.categories.find(params[:id])
      category.images.create!(name: "test_image", image: params[:image])
      redirect_to desktop_category_pictures_path(category), notice: 'Image uploaded'
    end

    def delete_category_picture
      category = current_organisation.categories.find(params[:id])

      image = category.images.find(params[:image_id])
      if category.images.count > 1
        image.destroy
        redirect_to desktop_category_pictures_path(category), notice: 'Image deleted'
      else
        redirect_to desktop_category_pictures_path(category), notice: 'Category needs to always have at least 1 photo'
      end
    end

    private

    def category_params
      params
        .require(:category)
        .permit(
          :name,
          :description
        )
    end
  end
end