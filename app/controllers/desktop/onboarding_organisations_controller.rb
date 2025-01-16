module Desktop
  class OnboardingOrganisationsController < DesktopController
    before_action :onboarding_organisation, except: [:user_details]

    skip_before_action :require_organisation
    skip_before_action :require_authenticated_user

    def user_details; end
    def update_user_details
      onboarding_organisation.update!(
        user_name: params[:name],
        email: params[:email],
        password: params[:password]
      )
    end

    def organisation_details; end
    def update_organisation_details
      onboarding_organisation.update!(
        name: params[:name],
        phone: params[:phone],
        address: params[:address],
        city: params[:city],
        postcode: params[:postcode]
      )
    end

    def complete; end
    def create_organisation
      organisation_attributes = onboarding_organisation.attributes.except("id", "user_name", "user_password", "created_at", "updated_at")
      organisation = Organisation.create!(organisation_attributes)
      user = organisation.users.create!(
        first_name: onboarding_organisation.user_name.split(" ").first,
        last_name: onboarding_organisation.user_name.split(" ").last,
        email: onboarding_organisation.email,
        password: onboarding_organisation.user_password
      )

      session["user"] ||= {}
      session["user"]["id"] = user.id
      redirect_to root_path
    end

    private

    def onboarding_organisation
      @onboarding_organisation ||= params[:id] ? OnboardingOrganisation.find(params[:id]) : OnboardingOrganisation.create!
    end
  end
end