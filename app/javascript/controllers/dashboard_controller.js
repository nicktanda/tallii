import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "timeSlot"]

  timeSlotTargetClicked(event) {
    const current_time = event.target.attributes["data-time"].value
    const current_date = event.target.attributes["data-date"].value
    const start_time_field = document.getElementById("start-time-field")
    start_time_field.value = current_time
    const date_field = document.getElementById("date-field")
    date_field.value = current_date
  }
}
