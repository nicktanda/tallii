class SettingsController < ApplicationController
  def index; end

  def pet_profiles; end
  def pet_profile
    @pet = Pet.find(params[:id])
  end

  def pet_selection; end

  def user_profile; end
  def update_user_profile; end
end