import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const id = event.currentTarget.dataset.replyFormTarget
    const form = document.getElementById(id)
    if (form) {
      form.classList.toggle("hidden")
    } else {
      console.warn(`No element found with id ${id}`)
    }
  }
}
