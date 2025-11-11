import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Phone input controller connected");
    // Clean any existing value on load
    if (this.inputTarget.value) {
      this.clean();
    }
  }

  clean(event) {
    const input = this.inputTarget;
    const cursorPosition = input.selectionStart;

    // Remove all non-numeric characters
    let cleaned = input.value.replace(/\D/g, '');

    // Limit to 15 digits (to accommodate international numbers)
    cleaned = cleaned.substring(0, 15);

    // Update the input value with only digits
    input.value = cleaned;

    // Maintain cursor position
    if (event) {
      input.setSelectionRange(cursorPosition, cursorPosition);
    }
  }
}
