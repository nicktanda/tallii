class GroomsController < ApplicationController
  def index
    pet = current_pet || current_user.pets.first
    @grooms = pet.grooms.all
  end

  def show
    @groom = Groom.find(params[:id])
  end

  def new; end

  def update
    groom = Groom.find(params[:id])
    groom.assign_attributes(groom_params)

    if groom.save
      redirect_to grooms_path, notice: 'Groom updated successfully'
    else
      redirect_back fallback_location: show_groom_path(groom), alert: 'Invalid groom information'
    end
  end

  def create
    groom = Groom.new(groom_params)

    if groom.save
      if params[:groom][:origin] == "desktop"
        redirect_to desktop_grooms_path, notice: 'Groom created successfully'
      else
        redirect_to grooms_path, notice: 'Groom created successfully'
      end
    else
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new, alert: 'Invalid groom information'
      else
        redirect_back fallback_location: new_groom_path, alert: 'Invalid groom information'
      end
    end
  end

  def delete
    groom = Groom.find(params[:id])

    if groom.destroy
      redirect_to grooms_path, notice: 'Groom deleted successfully'
    else
      redirect_back fallback_location: grooms_path, alert: 'Please try again'
    end
  end

  private

  def groom_params
    params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom)
  end
end