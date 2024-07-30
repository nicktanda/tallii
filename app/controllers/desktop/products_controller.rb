module Desktop
  class ProductsController < DesktopController
    def index
      @products = current_organisation.products
    end

    
  end
end