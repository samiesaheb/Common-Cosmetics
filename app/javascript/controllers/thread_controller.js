import { Controller } from "@hotwired/stimulus"

// Toggles visibility of a comment's replies
export default class extends Controller {
  static targets = ["replies", "toggleText"]

  connect() {
    // Start collapsed if replies exist
    if (this.hasRepliesTarget) this.close()
  }

  toggle(event) {
    // If user clicked a link/form/button inside, don't toggle
    if (this._isInteractive(event.target)) return

    this.element.classList.toggle("is-open")
    if (this.element.classList.contains("is-open")) {
      this.open()
    } else {
      this.close()
    }
  }

  stop(event) {
    event.stopPropagation()
  }

  open() {
    if (this.hasRepliesTarget) {
      this.repliesTarget.classList.remove("hidden")
      if (this.hasToggleTextTarget) this.toggleTextTarget.textContent = "Hide replies"
    }
  }

  close() {
    if (this.hasRepliesTarget) {
      this.repliesTarget.classList.add("hidden")
      if (this.hasToggleTextTarget) {
        const count = this.repliesTarget.dataset.count
        this.toggleTextTarget.textContent = `View replies${count ? ` (${count})` : ""}`
      }
    }
  }

  _isInteractive(el) {
    return el.closest("a, button, [role='button'], input, textarea, select, label, form")
  }
}
