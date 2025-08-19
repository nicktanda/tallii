module Desktop
  class OnboardingOrganisationsController < DesktopController
    before_action :onboarding_organisation, except: [:user_details]

    before_action :redirect_if_user_is_logged_in
    skip_before_action :require_organisation

    def user_details; end
    def update_user_details
      onboarding_organisation.update!(
        user_name: params[:name],
        email: params[:email],
        user_password: params[:user_password]
      )
      redirect_to desktop_onboarding_organisation_organisation_details_path(onboarding_organisation)
    end

    def organisation_details; end
    def update_organisation_details
      onboarding_organisation.update!(
        name: params[:name],
        phone: params["[country_code]"] + params["phone"],
        address: params[:address],
        city: params[:city],
        postcode: params[:postcode]
      )
    end

    def complete; end
    def create_organisation
      organisation_attributes = onboarding_organisation.attributes.except("id", "user_name", "user_password", "created_at", "updated_at")
      organisation = Organisation.create!(organisation_attributes.merge(name: params[:name], country: params[:country]))
      user = organisation.users.create!(
        first_name: onboarding_organisation.user_name.split(" ").first,
        last_name: onboarding_organisation.user_name.split(" ").last,
        email: onboarding_organisation.email,
        password: onboarding_organisation.user_password,
        role: "admin"
      )

      session["user"] ||= {}
      session["user"]["id"] = user.id

      onboarding_organisation.destroy

      redirect_to desktop_dashboard_path
    end

    private

    def onboarding_organisation
      @onboarding_organisation ||= params[:id] ? OnboardingOrganisation.find(params[:id]) : OnboardingOrganisation.create!
    end

    def redirect_if_user_is_logged_in
      redirect_to desktop_dashboard_path if current_user
    end
  end
end