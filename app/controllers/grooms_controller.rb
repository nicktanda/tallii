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
      redirect_to grooms_path
    else
      redirect_back fallback_location: groom_path(groom), alert: 'Invalid groom information'
    end
  end

  def create
    groom = current_organisation.grooms.new(groom_params)

    if current_organisation.grooms.today.count == current_organisation.maximum_daily_grooms
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
      else
        redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
      end
      return
    end

    if current_organisation.grooms.this_week.count == current_organisation.maximum_weekly_grooms
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
      else
        redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
      end
      return
    end

    if groom.save
      rewards_points = groom.pet.user.rewards_points + current_organisation.grooming_reward_points
      groom.pet.user.update!(rewards_points: rewards_points)
      groom.images.create!(name: "test_image", image: params[:groom][:image])
      if params[:groom][:origin] == "desktop"
        redirect_to desktop_grooms_path
      else
        redirect_to grooms_path
      end
    else
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'Invalid groom information'
      else
        redirect_back fallback_location: new_groom_path, alert: 'Invalid groom information'
      end
    end
  end

  def confirm
    groom = current_organisation.grooms.find(params[:id])

    if groom.update!(status: 'confirmed')
      redirect_to grooms_path
    else
      redirect_back fallback_location: grooms_path, alert: 'Please try again'
    end
  end

  def delete
    groom = current_organisation.grooms.find(params[:id])

    if groom.destroy
      redirect_to grooms_path
    else
      redirect_back fallback_location: grooms_path, alert: 'Please try again'
    end
  end

  private

  def groom_params
    params.require(:groom).permit(:date, :time, :notes, :pet_id, :last_groom, :employee_id)
  end
end