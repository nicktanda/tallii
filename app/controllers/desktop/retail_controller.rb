module Desktop
  class RetailController < DesktopController
    def index
      @products = current_organisation.products
    end
  end
end