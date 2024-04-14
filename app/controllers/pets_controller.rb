class PetsController < ApplicationController
  def index
    @pets = current_user.pets.all
  end

  def show
    @pet = Pet.find(params[:id])
  end
end