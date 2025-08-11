import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 200 } }

  connect() {
    this.form  = this.element.closest("form")
    this.input = this.element
    this.frame = document.getElementById("search_suggestions")
    this._timer = null

    // Ensure we start in suggestions mode on any page load
    this._onTurboLoad = () => {
      // 1) Always reset target back to suggestions after any navigation
      if (this.form) this.form.dataset.turboFrame = "search_suggestions"

      // 2) If we’re on the search results page with a query, clear the input
      const url = new URL(window.location.href)
      if (url.pathname.startsWith("/search") && url.searchParams.get("q")) {
        if (this.input) this.input.value = ""
        this.hide()
      }
    }

    document.addEventListener("turbo:load", this._onTurboLoad)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this._onTurboLoad)
  }

  debouncedSubmit() {
    clearTimeout(this._timer)
    this._timer = setTimeout(() => this.submit(), this.delayValue)
  }

  submit() {
    if (!this.form) return
    // Typing submits to the suggestions frame (form defaults to "search_suggestions")
    this.form.requestSubmit()
    this.show()
  }

  show() {
    if (this.frame) this.frame.classList.remove("hidden")
  }

  hide() {
    if (this.frame) this.frame.classList.add("hidden")
  }

  maybeHide() {
    // Delay hide so clicks on dropdown still work
    setTimeout(() => this.hide(), 120)
  }

  keepOpen(event) {
    // Prevent blur-triggered hide when interacting with dropdown
    event.preventDefault()
  }

  keys(event) {
    // ESC closes
    if (event.key === "Escape") {
      this.hide()
      event.target.blur()
    }

    // ENTER triggers full-page search (switch form target to _top)
    if (event.key === "Enter") {
      if (this.form) this.form.dataset.turboFrame = "_top"
    }
  }
}
