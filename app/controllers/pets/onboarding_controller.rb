module Pets
  class OnboardingController < ApplicationController
    before_action: :pet

    def new
      @pet = OnboardingPet.create!(user: current_user, organisation: current_user.organisation)
    end

    def species; end
    def update_species
      @pet.update!(species: params[:species])
      redirect_to pet_name_onboarding_path(@pet)
    end

    def name; end
    def update_name
      @pet.update!(name: params[:name])
      redirect_to pet_gender_onboarding_path(@pet)
    end

    def gender; end
    def update_gender
      @pet.update!(gender: params[:gender])
      redirect_to pet_dob_onboarding_path(@pet)
    end

    def dob; end
    def update_dob
      @pet.update!(dob: params[:dob])
      redirect_to pet_weight_onboarding_path(@pet)
    end

    def weight; end
    def update_weight
      @pet.update!(weight: params[:weight])
      redirect_to pet_breed_onboarding_path(@pet)
    end

    def breed; end
    def update_breed
      @pet.update!(breed: params[:breed])
      redirect_to pet_health_conditions_onboarding_path(@pet)
    end

    def health_conditions; end
    def update_health_conditions
      @pet.update!(health_conditions: params[:health_conditions])
      redirect_to pet_images_onboarding_path(@pet)
    end

    def images; end
    def upload_image
      @pet.images.create!(name: "test_image", image: params[:image])
    end

    def create_pet
      pet_attributes = @pet.attributes.except("id", "created_at", "updated_at")
      pet = current_user.pets.create!(pet_attributes)
      redirect_to pet_path(pet), notice: 'Pet created successfully'
    end

    private

    def pet
      @pet ||= OnboardingPet.find(params[:id])
    end
  end
end