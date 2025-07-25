import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  connect() {
    console.log("✅ Dropdown controller connected to:", this.element)
    this.hideBound = this.hide.bind(this)
    document.addEventListener("click", this.hideBound)
  }

  disconnect() {
    document.removeEventListener("click", this.hideBound)
  }
}
