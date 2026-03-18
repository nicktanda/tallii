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
      redirect_to grooms_path, notice: 'Groom updated'
    else
      redirect_back fallback_location: groom_path(groom), alert: 'Invalid groom information'
    end
  end

  def create
    # Handle new multi-booking format with individual dates/times per pet
    if params[:bookings].present?
      create_multiple_bookings
      return
    end

    # Legacy: Handle old format with pet_ids array (same time for all pets)
    pet_ids = params[:groom][:pet_ids].presence || [params[:groom][:pet_id]].compact

    if pet_ids.empty?
      redirect_back fallback_location: new_groom_path, alert: 'Please select at least one pet'
      return
    end

    # Use cached count methods from Organisation model for consistency
    if current_organisation.grooms_today_count + pet_ids.length > current_organisation.maximum_daily_grooms
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
      else
        redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
      end
      return
    end

    if current_organisation.grooms_this_week_count + pet_ids.length > current_organisation.maximum_weekly_grooms
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
      else
        redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
      end
      return
    end

    created_grooms = []
    errors = []

    pet_ids.each do |pet_id|
      groom = current_organisation.grooms.new(groom_params_without_pets.merge(pet_id: pet_id))
      if groom.save
        groom.images.create!(name: "test_image", image: params[:groom][:image]) if params[:groom][:image].present?
        created_grooms << groom
      else
        errors << "Failed to create groom for pet #{pet_id}"
      end
    end

    if errors.empty?
      notice = pet_ids.length > 1 ? "#{pet_ids.length} groom appointments saved" : 'Groom appointment saved'
      if params[:groom][:origin] == "desktop"
        redirect_to desktop_grooms_path, notice: notice
      else
        redirect_to grooms_path, notice: notice
      end
    else
      if params[:groom][:origin] == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'Some groom appointments could not be created'
      else
        redirect_back fallback_location: new_groom_path, alert: 'Some groom appointments could not be created'
      end
    end
  end

  def confirm
    groom = current_organisation.grooms.find(params[:id])

    if groom.update!(status: 'confirmed')
      redirect_to grooms_path, notice: 'Groom confirmed'
    else
      redirect_back fallback_location: grooms_path, alert: 'Please try again'
    end
  end

  def delete
    groom = current_organisation.grooms.find(params[:id])

    if groom.destroy
      redirect_to grooms_path, notice: 'Groom deleted'
    else
      redirect_back fallback_location: grooms_path, alert: 'Please try again'
    end
  end

  private

  def create_multiple_bookings
    bookings = params[:bookings]
    origin = params[:groom][:origin]

    if bookings.blank?
      redirect_back fallback_location: new_groom_path, alert: 'Please select at least one pet'
      return
    end

    # Use cached count methods from Organisation model for consistency
    if current_organisation.grooms_today_count + bookings.length > current_organisation.maximum_daily_grooms
      if origin == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
      else
        redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms today, please rebook for another day'
      end
      return
    end

    if current_organisation.grooms_this_week_count + bookings.length > current_organisation.maximum_weekly_grooms
      if origin == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
      else
        redirect_back fallback_location: new_groom_path, alert: 'We are unable to take any extra grooms this week, please rebook for another week'
      end
      return
    end

    created_grooms = []
    errors = []

    bookings.each do |booking_params|
      permitted = booking_params.permit(:pet_id, :date, :start_time, :end_time, :employee_id, :notes, :status)
      groom = current_organisation.grooms.new(permitted)

      if groom.save
        created_grooms << groom
      else
        pet = Pet.find_by(id: booking_params[:pet_id])
        errors << "Failed to create groom for #{pet&.name || 'pet'}"
      end
    end

    if errors.empty?
      notice = bookings.length > 1 ? "#{bookings.length} groom appointments saved" : 'Groom appointment saved'
      if origin == "desktop"
        redirect_to desktop_grooms_path, notice: notice
      else
        redirect_to grooms_path, notice: notice
      end
    else
      if origin == "desktop"
        redirect_back fallback_location: desktop_grooms_new_path, alert: 'Some groom appointments could not be created'
      else
        redirect_back fallback_location: new_groom_path, alert: 'Some groom appointments could not be created'
      end
    end
  end

  def groom_params
    params.require(:groom).permit(:date, :start_time, :end_time, :notes, :pet_id, :last_groom, :employee_id, :status, pet_ids: [])
  end

  def groom_params_without_pets
    params.require(:groom).permit(:date, :start_time, :end_time, :notes, :last_groom, :employee_id, :status)
  end
end