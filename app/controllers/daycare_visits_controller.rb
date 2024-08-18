class DaycareVisitsController < ApplicationController
  def index
    pet = current_pet || current_user.pets.first
    @daycare_visits = pet.daycare_visits
  end

  def show
    @daycare_visit = current_organisation.daycare_visits.find(params[:id])
  end

  def new; end

  def update
    daycare_visit = current_organisation.daycare_visits.find(params[:id])
    daycare_visit.assign_attributes(visit_params)

    if daycare_visit.save
      redirect_to daycare_visits_path, notice: 'Daycare visit updated successfully'
    else
      redirect_back fallback_location: show_daycare_visit_path(daycare_visit), alert: 'Invalid daycare visit information'
    end
  end

  def create
    daycare_visit = current_organisation.daycare_visits.new(visit_params)

    if daycare_visit.save
      if params[:daycare_visit][:origin] == "desktop"
        redirect_to desktop_daycare_visits_path, notice: 'Daycare visit created successfully'
      else
        redirect_to daycare_visits_path, notice: 'Daycare visit created successfully'
      end
    else
      if params[:daycare_visit][:origin] == "desktop"
        redirect_back fallback_location: new_daycare_visits_path, alert: 'Invalid daycare visit information'
      else
        redirect_back fallback_location: desktop_daycare_visits_new_path, alert: 'Invalid daycare visit information'
      end
    end
  end

  def delete
    daycare_visit = current_organisation.daycare_visits.find(params[:id])

    if daycare_visit.destroy
      redirect_to daycare_visits_path, notice: 'Daycare visit deleted successfully'
    else
      redirect_back fallback_location: daycare_visits_path, alert: 'Please try again'
    end
  end

  private

  def visit_params
    params.require(:daycare_visit).permit(:date, :time, :notes, :pet_id, :duration, :employee_id)
  end
end