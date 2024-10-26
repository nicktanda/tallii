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
      redirect_to daycare_visits_path
    else
      redirect_back fallback_location: show_daycare_visit_path(daycare_visit), alert: 'Invalid daycare visit information'
    end
  end

  def create
    daycare_visit = current_organisation.daycare_visits.new(visit_params)

    if daycare_visit.pet.user.max_daycare_visits == 0
      if params[:daycare_visit][:origin] == "desktop"
        redirect_back fallback_location: desktop_daycare_visits_new_path, alert: 'User has no more daycare visits in their package. Please confirm the customer would like more daycare visits'
      else
        redirect_back fallback_location: new_daycare_visits_path, alert: 'You have reached your maximum number of daycare visits'
      end
      return
    end

    if current_organisation.daycare_visits.today.count == current_organisation.maximum_daily_daycare_visits
      if params[:daycare_visit][:origin] == "desktop"
        redirect_back fallback_location: desktop_daycare_visits_new_path, alert: 'We are unable to take any extra daycare visits today, please rebook for another day'
      else
        redirect_back fallback_location: new_daycare_visits_path, alert: 'We are unable to take any extra daycare visits today, please rebook for another day'
      end
      return
    end

    if current_organisation.daycare_visits.this_week.count == current_organisation.maximum_weekly_daycare_visits
      if params[:daycare_visit][:origin] == "desktop"
        redirect_back fallback_location: desktop_daycare_visits_new_path, alert: 'We are unable to take any extra daycare visits this week, please rebook for another week'
      else
        redirect_back fallback_location: new_daycare_visits_path, alert: 'We are unable to take any extra daycare visits this week, please rebook for another week'
      end
      return
    end

    if daycare_visit.save
      rewards_points = daycare_visit.pet.user.rewards_points + current_organisation.daycare_visit_reward_points
      max_visits = daycare_visit.pet.user.max_daycare_visits - 1
      daycare_visit.pet.user.update!(rewards_points: rewards_points, max_daycare_visits: max_visits)
      if params[:daycare_visit][:origin] == "desktop"
        redirect_to desktop_daycare_visits_path
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

  def confirm
    daycare_visit = current_organisation.daycare_visits.find(params[:id])

    if daycare_visit.update!(status: 'confirmed')
      redirect_to daycare_visits_path
    else
      redirect_back fallback_location: daycare_visits_path, alert: 'Please try again'
    end
  end

  def delete
    daycare_visit = current_organisation.daycare_visits.find(params[:id])

    if daycare_visit.destroy
      redirect_to daycare_visits_path
    else
      redirect_back fallback_location: daycare_visits_path, alert: 'Please try again'
    end
  end

  private

  def visit_params
    params.require(:daycare_visit).permit(:date, :time, :notes, :pet_id, :duration, :employee_id)
  end
end