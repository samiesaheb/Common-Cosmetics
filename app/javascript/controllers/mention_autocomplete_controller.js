// app/javascript/controllers/mention_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"]

  connect() {
    this.reset()
  }

  reset() {
    this.query = ""
    this.startIndex = null
    this.suggestionsTarget.innerHTML = ""
  }

  onInput(event) {
    const cursorPos = this.inputTarget.selectionStart
    const text = this.inputTarget.value.slice(0, cursorPos)
    const atIndex = text.lastIndexOf("@")

    if (atIndex === -1 || /\s/.test(text.slice(atIndex - 1, atIndex))) {
      this.reset()
      return
    }

    this.query = text.slice(atIndex + 1)
    this.startIndex = atIndex

    if (this.query.length > 0) {
      this.fetchSuggestions()
    } else {
      this.suggestionsTarget.innerHTML = ""
    }
  }

  fetchSuggestions() {
    fetch(`/users/autocomplete?query=${this.query}`)
      .then(res => res.json())
      .then(users => {
        this.showSuggestions(users)
      })
  }

  showSuggestions(users) {
    this.suggestionsTarget.innerHTML = users.map(user => `
      <div class="mention-item cursor-pointer px-2 py-1 hover:bg-gray-100 dark:hover:bg-gray-800"
           data-action="mousedown->mention-autocomplete#insert"
           data-username="@${user.username}">
        @${user.username}
      </div>
    `).join("")
  }

  insert(event) {
    const username = event.currentTarget.dataset.username
    const text = this.inputTarget.value
    const before = text.slice(0, this.startIndex)
    const after = text.slice(this.inputTarget.selectionStart)
    this.inputTarget.value = `${before}${username} ${after}`
    this.reset()
  }
}
