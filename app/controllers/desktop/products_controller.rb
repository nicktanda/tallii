module Desktop
  class ProductsController < DesktopController
    def index
      @products = current_organisation.products
    end

    def new; end
    
    def create

    end

    def show
      @product = current_organisation.products.find(params[:id])
    end
  end
end