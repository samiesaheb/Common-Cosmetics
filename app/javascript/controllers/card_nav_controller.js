import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  go(event) {
    // ignore if user is selecting text or clicking a control / excluded area
    if (window.getSelection()?.toString()) return
    if (event.target.closest("a,button,input,textarea,[data-no-nav]")) return
    this.visit()
  }

  key(event) {
    if (event.key === "Enter" || event.key === " ") {
      if (event.target.closest("a,button,input,textarea,[data-no-nav]")) return
      event.preventDefault()
      this.visit()
    }
  }

  visit() {
    const url = this.urlValue
    if (!url) return
    if (window.Turbo && Turbo.visit) {
      Turbo.visit(url)
    } else {
      window.location = url
    }
  }
}
