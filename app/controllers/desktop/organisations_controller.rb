module Desktop
  class OrganisationsController < DesktopController
    skip_before_action :require_organisation

    def new; end

    def create
      organisation = Organisation.new(organisation_params)

      if organisation.save
        current_user.update(organisation_id: organisation.id)
        redirect_to desktop_dashboard_path
      else
        redirect_back fallback_location: desktop_organisations_new_path, alert: 'Invalid organisation information'
      end
    end

    private

    def organisation_params
      params.require(:organisation).permit(:name, :email, :phone, :address, :city, :postcode)
    end
  end
end