import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const id = this.element.dataset.replyFormTarget
    const form = document.getElementById(id)
    form?.classList.toggle("hidden")
  }
}
