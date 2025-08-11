import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const commentId = event.currentTarget.dataset.commentId
    const form = document.getElementById(`reply-form-${commentId}`)
    if (form) form.classList.toggle("hidden")
  }
}
