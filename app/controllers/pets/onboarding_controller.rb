module Pets
  class OnboardingController < ApplicationController
    before_action: :pet

    def new
      @pet = OnboardingPet.create!(user: current_user, organisation: current_user.organisation)
    end

    def species; end
    def update_species
      @pet.update!(species: params[:species])
    end

    def name; end
    def update_name
      @pet.update!(name: params[:name])
    end

    def gender; end
    def update_gender
      @pet.update!(gender: params[:gender])
    end

    def dob; end
    def update_dob
      @pet.update!(dob: params[:dob])
    end

    def weight; end
    def update_weight
      @pet.update!(weight: params[:weight])
    end

    def breed; end
    def update_breed
      @pet.update!(breed: params[:breed])
    end

    def health_conditions; end
    def update_health_conditions
      @pet.update!(health_conditions: params[:health_conditions])
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