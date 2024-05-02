class GroomsController < ApplicationController
  def index
    pets = current_user.pets.all.includes(:grooms)
    @grooms = pets.map(&:grooms).flatten
  end

  def show
    @groom = Groom.find(params[:id])
  end

  def new; end

  def create; end

  def groom_params
    params.require(:groom).permit(:date, :time, :notes, :pet_id)
  end
end