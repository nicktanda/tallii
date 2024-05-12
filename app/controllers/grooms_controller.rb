class GroomsController < ApplicationController
  def index
    pets = current_user.pets.all.includes(:grooms)
    @grooms = pets.map(&:grooms).flatten
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
      redirect_to grooms_path, notice: 'Groom created successfully'
    else
      redirect_back fallback_location: new_groom_path, alert: 'Invalid groom information'
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