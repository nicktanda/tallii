class GroomsController < ApplicationController
  def index
    pets = current_user.pets.all.includes(:grooms)
    @grooms = pets.map(&:grooms).flatten
  end

  def show
    @groom = Groom.find(params[:id])
  end

  def new; end

  def create
    groom = Groom.new(groom_params)

    if groom.save
      redirect_to grooms_path, notice: 'Groom created successfully'
    else
      redirect_back fallback_location: new_groom_path, alert: 'Invalid groom information'
    end
  end

  def groom_params
    params.require(:groom).permit(:date, :time, :notes, :pet_id)
  end
end