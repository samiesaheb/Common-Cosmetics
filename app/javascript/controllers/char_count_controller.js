import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["counter"]
  static values = { max: Number }

  connect() { this.update() }

  update() {
    const len = this.element.value?.length || 0
    const max = this.hasMaxValue ? this.maxValue : 0
    if (this.hasCounterTarget) this.counterTarget.textContent = len
    if (max && len > max) this.element.value = this.element.value.slice(0, max)
  }
}
