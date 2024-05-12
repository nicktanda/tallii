class DaycareVisitsController < ApplicationController
  def index
    pets = current_user.pets.all.includes(:daycare_visits)
    @grooms = pets.map(&:daycare_visits).flatten
  end

  def show
    @groom = DaycareVisit.find(params[:id])
  end

  def new; end

  def update
    daycare_visit = DaycareVisit.find(params[:id])
    daycare_visit.assign_attributes(visit_params)

    if daycare_visit.save
      redirect_to daycare_visits_path, notice: 'Daycare visit updated successfully'
    else
      redirect_back fallback_location: show_daycare_visit_path(daycare_visit), alert: 'Invalid daycare visit information'
    end
  end

  def create
    daycare_visit = DaycareVisit.new(visit_params)

    if daycare_visit.save
      redirect_to daycare_visits_path, notice: 'Daycare visit created successfully'
    else
      redirect_back fallback_location: new_daycare_visits_path, alert: 'Invalid daycare visit information'
    end
  end

  def delete
    daycare_visit = daycare_visit.find(params[:id])

    if daycar_visit.destroy
      redirect_to daycare_visits_path, notice: 'Daycare visit deleted successfully'
    else
      redirect_back fallback_location: daycare_visits_path, alert: 'Please try again'
    end
  end

  private

  def visit_params
    params.require(:daycare_visit).permit(:date, :time, :notes, :pet_id, :duration)
  end
end