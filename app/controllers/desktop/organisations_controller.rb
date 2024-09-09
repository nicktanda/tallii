module Desktop
  class OrganisationsController < DesktopController
    def new

    end

    def create
      
    end

    private

    def organisation_params
      params.require(:organisation).permit(:name, :email, :phone, :address, :city, :postcode)
    end
  end
end