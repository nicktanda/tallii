class GroomsController < ApplicationController
  def index
    pet = current_pet || current_user.pets.first
    @grooms = pet.grooms.all
  end

  def show
    @groom = current_organisation.grooms.find(params[:id])
  end

  def new; end

  def update
    groom = current_organisation.grooms.find(params[:id])
    groom.assign_attributes(groom_params)

    if groom.save
      redirect_to grooms_path, notice: 'Groom updated successfully'
    else
      redirect_back fallback_location: show_groom_path(groom), alert: 'Invalid groom information'
    end
  end

  def create
    groom = current_organisation.grooms.new(groom_params)

    if current_organisation.grooms.today.count == current_organisation.maximum_daily_grooms
      redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
    end

    if current_organisation.grooms.this_week.count == current_organisation.maximum_weekly_grooms
      redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
    end

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
    groom = current_organisation.grooms.find(params[:id])

    if groom.destroy
      redirect_to grooms_path, notice: 'Groom deleted successfully'
    else
      redirect_back fallback_location: grooms_path, alert: 'Please try again'
    end
  end

  private

  def groom_params
    params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom, :employee_id)
  end
end