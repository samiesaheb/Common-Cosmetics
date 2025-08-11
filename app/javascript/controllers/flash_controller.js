// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-hide after 3 seconds
    this.timeout = setTimeout(() => {
      this.fadeAndRemove()
    }, 3000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  fadeAndRemove() {
    this.element.style.opacity = "0"
    setTimeout(() => this.element.remove(), 500) // matches transition duration
  }
}
