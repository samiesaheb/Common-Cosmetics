import { Controller } from "@hotwired/stimulus"

// Scrolls to the bottom of the container when new content is added
export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    const el = this.containerTarget
    el.scrollTop = el.scrollHeight
  }

  // Called automatically when Turbo renders new content
  afterRender() {
    this.scrollToBottom()
  }
}
